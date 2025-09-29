module DebugModuleInterface (
    //dmi inputs
    input  wire        clk,
    input  wire        rst,
    input  wire [6:0]  dmi_address_in,
    input  wire        dmi_read,
    input  wire        dmi_write,
    input  wire [31:0] dmi_writedata,
    input  wire        dmi_ready,
    input  wire [31:0] reg_read,
    input  wire [31:0] progbufinstr, 
    //hart info either from hart or from JTAG
    // input  wire        allhartsresumeack,
    // input  wire        anyhartresumeack,
    // input  wire        allnonexistenthart,
    // input  wire        anynonexistenthart,
    // input  wire        allunavailhart,
    // input  wire        anyunavailhart,
    // input  wire        allrunninghart,
    // input  wire        anyrunninghart,
    // input  wire        allhaltedhart,
    // input  wire        anyhaltedhart,

    //dmi outputs
    output  reg [31:0]  dmi_readdata,
    output  reg [6:0] dmi_address_out,
    //hart info output
    // output reg         SETRESETHALTREQ,
    // output reg         CLRRESETHALTREQ,
    // output reg         HARTRESETCOM
    output  reg [4:0]   reg_address,
    output  reg [31:0]  reg_write
);
    wire hartreset , hasel, data0 , data1;
    wire [14:0] hawsel; 
    wire [31:0] maskdata;
    reg [7:0] cmdtype, sbasize;
    wire [23:0] control;
    reg haltreq, resumereq, haveackrst;
    wire [9:0] hartsello, hartselhi;
    wire [19:0] hartsel;
    reg setresethaltreq, clrresethaltreq;
    // reg hasel = 1'b0;
    // reg [31:0] haseldata = 32'd1;
    reg impebreak, allhavereset, anyhavereset, sbaccess128, sbaccess64, sbaccess32, sbaccess16, sbaccess8;
    reg allresumeack, anyresumeack, sbbusyerror, sbbusy,sbreadonaddr;
    reg allnonexistent, anynonexistent, sbautoincreament,sbreadondata;
    reg allunavail, anyunavail;
    reg allrunning, anyrunning;
    reg allhalted, anyhalted;
    reg AUTHENTICATED, AUTHBUSY, HASRESETHALTREQ, CONSFSTRPTRVALID;
    reg SETRESETHALTREQ, CLRRESETHALTREQ;
    reg [3:0] VERSION, sbversion, abaccess, sberror;
    reg [15:0] regno;
    reg write, transfer, postexec, aarpostincrement, aarsize, cmdtype;
    reg [4:0] PROGBUFSIZE;
    reg [31:0] confstr_address;
    reg datacount;

    localparam num_of_hart = 33;
    reg [num_of_hart:0] HAMR; 
    reg [31:0] progbuff [0:14];
    integer val;

    //both data 0 and 1 are used for arg0 and arg1 respectively for 32 bit instruction
    //i personally only implemented these since my core is of 32 bit instruction
    localparam abstractdata0  = 7'h04;
    localparam abstractdata1  = 7'h05;

    localparam dmcontrol      = 7'h10;
    localparam dmstatus       = 7'h11;
    localparam hartinfo       = 7'h12;
    localparam haltsum0       = 7'h40;
    localparam haltsum1       = 7'h13;
    localparam hawindowsel    = 7'h14;
    localparam hawindow       = 7'h15;
    localparam abstractcs     = 7'h16;
    localparam command        = 7'h17;
    localparam confstrptr0    = 7'h19;      //only implemented confstrptr0 since it is valid for 32bit systems
    localparam nextdm         = 7'h1d;
    localparam authdata       = 7'h30;      //will implement after authentication module
    localparam sbcs           = 7'h38;

    initial begin
        integer i;
        for(i=0; i<15; i++) begin       //clearing the progbuff
            AUTHENTICATED = 1;          //assuming session level handshake is established
            progbuff[i] = 32'd0;
            PROGBUFSIZE = 5'd0;
            datacount = 2;
            val = 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dmi_readdata <= 32'b0;
            SETRESETHALTREQ <= 1'b0;
            CLRRESETHALTREQ <= 1'b0;
            HARTRESETCOM <= 1'b0;
        end else if (dmi_ready && AUTHENTICATED) begin
            case (dmi_address_in)
                abstractdata0: begin
                    if (dmi_read) begin
                        data0 <= dmi_writedata;
                        $display("abstractdata0 write: %h at time %0t", dmi_writedata, $time);
                    end
                    if (dmi_write)  dmi_readdata <= data0;
                end
                abstractdata1: begin
                    if (dmi_read) begin
                        data1 <= dmi_writedata;
                        $display("abstractdata1 write: %h at time %0t", dmi_writedata, $time);
                    end
                    if (dmi_write)  dmi_readdata <= data1;
                end
                dmcontrol: begin
                    dmcontroltsk(dmi_writedata);
                end
                dmstatus: begin
                    if (dmi_read)  dmstatustsk(dmi_writedata);
                end
                hartinfo: begin
                    if (dmi_read) begin
                    $display("hartinfo (NOT IMPLEMENTED) read at time %0t", $time);
                    dmi_readdata <= 32'd0;
                    end
                end
                if (num_of_hart > 32) begin
                    haltsum1: if(dmi_read) begin
                        haltsumtsk(dmi_readdata);
                    end 
                end
                hawindowsel: begin
                    if (dmi_write)  hawsel <= dmi_writedata[14:0];
                    if (dmi_read) dmi_readdata[14:0] <= hawsel;
                end
                hawindow: begin
                    if (dmi_write)   maskdata <= dmi_writedata;
                    if (dmi_read)  hawindowtsk(maskdata); 
                end
                abstractcs: begin
                    if (dmi_read)  abstractcstsk(dmi_readdata,dmi_writedata);
                end
                command: begin
                    if (dmi_write && cmderr == 3'd0) begin
                        cmdtype <= [31:24] dmi_writedata;
                        control <= [23:0] dmi_writedata;
                        abstract_command_listingtsk(cmdtype,control);
                    end
                end
                confstrptr0: begin
                    if(dmi_read) begin
                        confstrptrtsk();
                    end                    
                end
                nextdm: begin
                    if (dmi_read) begin
                        dmi_readdata <= 32'd0;  //since only one dm implemented. 
                    end
                end
                haltsum0: begin
                    if (dmi_read) haltsum0();
                end
                sbcs: begin
                    sysbusaddrcontsk();
                end
                default: begin
                    dmi_readdata <= 32'b0;
                end
            endcase
        end
        else begin
            if (~AUTHENTICATED) begin
               $display("Authentication is required before using the DM."); 
            end 
            else $display("DM is not ready.");
        end
    end
    task progbufftsk;
        input [31:0] data;
        if(busy) begin
            cmderr <= 3'd1; 
            if(busy && PROGBUFSIZE == val) begin
                progbuff[val] <= data;
                dmi_readdata <= progbuff[val];
                dmi_address_out <= 7'h20 + val;
                if (val < 15) PROGBUFSIZE <= 5'd1 + val;
                val = val + 1;
                busy = 0;
            end

            if (PROGBUFSIZE == 15) begin
                $display("program buffer overflow");
                progbufferror <= 1;
            end

            else begin
                if(allhalted || anyhalted) begin
                val = 0;
                PROGBUFSIZE = 5'd0; 
                end
                progbufferror <= 1;
            end    
        end
    endtask

    task dmcontroltsk;
        input [31:0] data;
        begin
            if (dmi_read) begin
                dmi_readdata[29] <= hartreset;
                dmi_readdata[26] <= hasel;
                dmi_readdata[25:16] <= hartsello;
                dmi_readdata[15:6] <= hartselhi;
            end
            if (dmi_write) begin
                haltreq <= (allhalted || anyhalted) ? 1 : 0;  
                if (haltreq) resumereq <= 0; 
                if (resumereq) haltreq <= 0;   
                hartreset <= (allhavereset || anyhavereset) ? 1 : 0;
                if (hartreset) haveackrst <= 1;
                allhavereset <= ~haveackrst;
                anyhavereset <= ~haveackrst; 
                hasel <= data[26];
                hartsello <= data[25:16];
                hartselhi <= data[15:6];
                hartsel [9:0]  <= hartsello;
                hartsel [19:10] <= hartselhi;
                setresethaltreq <= data[3];
                clrresethaltreq <= data[2];
            end if (HASRESETHALTREQ) begin
                    SETRESETHALTREQ <= data[3];
                    CLRRESETHALTREQ <= data[2];
                end else begin
                    SETRESETHALTREQ <= 0;
                    CLRRESETHALTREQ <= 0;
                end
        end
    endtask

    task dmstatustsk;
        input [31:0] datao;
        // reg impebreak, allhavereset, anyhavereset;
        // reg allresumeack, anyresumeack;
        // reg allnonexistent, anynonexistent;
        // reg allunavail, anyunavail;
        // reg allrunning, anyrunning;
        // reg allhalted, anyhalted;
        begin
            // impebreak = (PROGBUFSIZE > 0);
            // allhavereset = ~haveackrst;
            // anyhavereset = ~haveackrst;
            // allresumeack = allhartsresumeack;
            // anyresumeack = anyhartresumeack;
            // allnonexistent = allnonexistenthart;
            // anynonexistent = anynonexistenthart;
            // allunavail = allunavailhart;
            // anyunavail = anyunavailhart;
            // allrunning = allrunninghart;
            // anyrunning = anyrunninghart;
            // allhalted = allhaltedhart;
            // anyhalted = anyhaltedhart;

            impebreak <= datao[22] ;
            allhavereset <= datao[19] ;
            anyhavereset <= datao[18] ;
            allresumeack <= datao[17] ;
            anyresumeack <= datao[16] ;
            allnonexistent <= datao[15] ;
            anynonexistent <= datao[14] ;
            allunavail <= datao[13] ;
            anyunavail <= datao[12] ;
            allrunning <= datao[11] ;
            anyrunning <= datao[10] ;
            allhalted <= datao[9]  ;
            anyhalted <= datao[8]  ;
            AUTHENTICATED <= datao[7]  ;
            AUTHBUSY <= datao[6]  ;
            HASRESETHALTREQ <= datao[5]  ;
            CONSFSTRPTRVALID <= datao[4]  ;
            VERSION <= datao[3:0];
        end
    endtask


    task hawindowtsk;
        input   [31:0] write_data;
        integer haindx,i;  
        if(dmi_write && num_of_hart > 32) begin
        for (i=0; i<32; i++) begin
            haindx = hawsel * 32 + i;
            if(haindx < num_of_harts)   HAMR [haindx] = write_data [i];
        end
        end     
    endtask

// >>> py logic (harts < 1024) >>> haltsum0 and haltsum1 
// ... index = 0x00
// ... next = 0x00
// ... HAMR = []
// ... for i in range (0,32):
// ...     next = i * 32 + 32
// ...     for j in range (next-32,next):
// ...         HAMR.append(j)
// ...     index = i
// ...     print(f"{index} -> {next}") #for haltsum1 group of harts 
// ...     print(f"----> {HAMR}") #for haltsum0 individual harts
// ...     HAMR.clear()

  task haltsum0;
    reg [31:0] haltsum0_data;
    integer i;
    reg [4:0] local_hartid;
    begin
        baseid = hartsel[19:5] << 5;
        for (i = 0; i < 32; i = i + 1) begin
                hartid = baseid + i;
                haltsum1_data [i] = hart_is_halted(hartid);
        end
        dmi_readdata <= haltsum0_data;
    end
  endtask

  task haltsum1;
    reg [31:0] haltsum1_data;
    integer i;
    wire [9:0] hartid;
    wire [9:0] baseid;
    begin
    baseid = hartsel[19:10] << 10;
        for (i = 0; i < 32; i = i + 1) begin
                hartid = baseid + i;
                haltsum1_data [i] = hart_is_halted(hartid);
            end
    dmi_readdata <= haltsum1_data;
    end
  endtask

    //implementation for at least 1024 harts
    task haltsumtsk;
        input read_data;
        integer LSB,MSB,i,j,count;
        count = 0;
        wire [31:0] SplitReg;
        for(i=0; i<32; i++) begin
            if(read_data[i]) $display("At least one hart of this group is halted"); 
                else $display("No Hart in this group is halted"); 
            LSB = i * 32;
            MSB = i * 32 + 31;
            if(MSB < num_of_hart)   begin
               SplitReg = HAMR[MSB:LSB];
               $display("For %h the register range is MASK REG [%h : %h] : %b",i,LSB,MSB,SplitReg); 
               for(j=0; j<32; j++) begin
                    if(SplitReg[j]) begin
                        $display("HAMR[%d] is halted",j);
                        count = count + 1;
                    end
               end
               $display("No of harts Halted: %d",count);
            end
        end

    endtask

    task abstractcstsk;
        input   [31:0] write_data;

        if(dmi_read) begin
            dmi_readdata  [28:24] <= PROGBUFSIZE; 
            dmi_readdata  [12]    <= busy;
            dmi_readdata  [3:0]   <= datacount;
        end

        if (~busy) begin
            case (cmderr)
                3'd1: dmi_readdata[10:8] <= 3'b001;
                3'd2: dmi_readdata[10:8] <= 3'b010;
                3'd3: dmi_readdata[10:8] <= 3'b011;
                3'd4: dmi_readdata[10:8] <= 3'b100;
                3'd5: dmi_readdata[10:8] <= 3'b101;
                3'd7: dmi_readdata[10:8] <= 3'b111;
                default: dmi_readdata[10:8] <= 3'b000;
            endcase
        end

        else dmi_readdata  [10:8]  <= cmderr;
 
    endtask

    task abstract_command_listingtsk;
        input [7:0] cmdtype;
        input [23:0] control;

        if(cmderr == 3'd0 && cmderr != 3'd4) begin
            cmderr = 3'd1;
            case(cmdtype) 
            8'd0: begin         //access command register
                busy = 1;
                regno <= [15:0] control;
                write <= [16] control;
                transfer <= [17] control;
                postexec <= [18] control;
                aarpostincrement <= [19] control;
                aarsize <= [22:20] control;
            
                case (aarsize) 
                3'd2: begin
                    $display("Accessing Lowest 32 bits of register [%h] at time %0t",regno,$time);
                end
                3'd3: begin
                    $display("register size with 64 bits not implemented, access failed!");
                    transfer = 0;
                end
                4'd4: begin
                    $display("register size with 128 bits not implemented, access failed!");
                    transfer = 0;
                end
                default: begin
                    $display("register size is invalid, access failed!");
                    transfer = 0;
                end
                endcase

            if(transfer) begin
                if(~write) begin
                reg_address <= [4:0] regno;
                if(reg_read == 32'dxxxx)  cmderr <= 3'd7;    
                else data0 <= reg_read;                    
                end
                else begin
                    reg_address <= [4:0] regno;
                    if(data0 == 32'dxxxx)  cmderr <= 3'd7;    
                    else reg_write <= data0;
                end
            end

            if(aarpostincrement) regno <= regno + 1;

            if(PROGBUFSIZE == 5'd0 && transfer) begin
                if(postexec) begin
                    progbufftsk(progbufinstr);          //progbuff execution
                end
            end    

            end
            8'd1: begin
                busy = 1;
                if(~anyhalted || ~allhalted) begin
                    haltreq <= 1;
                    if(impebreak) cmderr <= 3'd4;
                    else begin 
                        postexec <= 1;
                        if (progbufferror) begin        //progbufferror is considered as exception
                        postexec <= 0;
                        cmderr <= 3'd3; 
                        end
                    end
                    resumereq <= 1;
                end
            end

            8'd2: begin
                busy = 1;
                ammvirtual = [23] control;
                aamsize = [22:30] control;
                aampostincrement = [19] control;
                write = [16] control;
                target_specific = [15:14] control;
                integer noofbytes;

                if(ammvirtual) $display("Addresses are virtual and translated from M-Mode with MPRV set.");
                else  $display("Addresses are physical.");
                case(aamsize) 
                    3'd0: begin $display("Access the lowest 8 bit of memory location."); noofbytes = 1; end
                    3'd1: begin $display("Access the lowest 16 bit of memory location."); noofbytes = 2; end
                    3'd2: begin $display("Access the lowest 32 bit of memory location."); noofbytes = 4; end
                    3'd3: begin $display("Access the lowest 64 bit of memory location."); noofbytes = 8; end
                    3'd4: begin $display("Access the lowest 128 bit of memory location."); noofbytes = 16; end
                    default: cmderr = 3'd2;
                endcase

                case (write)
                    1: begin
                        mem_address <= arg1;
                        mem_data_o <= arg0;    
                    end 
                    0: begin
                        mem_address <= arg1;
                        arg0 <= mem_data_i;
                    end
                    default: cmderr = 3'd2;
                endcase

                if (aampostincrement) begin
                    arg1 <= arg1 + noofbytes;
                end
            end
            endcase
            busy = 0;
            cmderr = 3'd0;
        end
    endtask

task confstrptrtsk;
if(CONSFSTRPTRVALID) begin
    confstr_address = dmi_writedata;
    //system bus implementaion will come here.
end
else $display("confstrptr0 register do not contain a valid mem address.");  
endtask

task sysbusaddrcontsk;
    begin
        if(read_data) begin
            sbversion <= [31:29] dmi_writedata;     
            sbbusyerror <= [22] dmi_writedata;
            sbbusy <= [21] dmi_writedata;
            if (sbbusy) sbbusyerror <= 1;
        end
    end
endtask


function hart_is_halted;
    input [9:0] hartid;
    begin
        hart_is_halted = (hartid == 10'd0) ? anyhalted : 0; //for first hart
    end
endfunction

function hart_is_available;
    input [9:0] hartid;
    begin
        hart_is_available = (hartid == 10'd0) ? ~anyunavail : 0; //for first hart
    end
endfunction

endmodule

