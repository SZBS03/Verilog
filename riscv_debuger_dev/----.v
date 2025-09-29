module DebugModuleInterface (
    input  wire        clk,
    input  wire        rst,
    input  wire [6:0]  dmi_address_in,
    input  wire        dmi_read,
    input  wire        dmi_write,
    input  wire [31:0] dmi_writedata,
    input  wire        dmi_ready,
    input  wire [31:0] reg_read,
    input  wire [31:0] progbufinstr, 

    output reg [31:0]  dmi_readdata,
    output reg [6:0]   dmi_address_out,
    output reg [4:0]   reg_address,
    output reg [31:0]  reg_write
);

    // Internal signals and registers
    reg [9:0] hartsel_hi, hartsel_lo;
    reg [31:0] sbaddress0_reg, sbdata0_reg;
    reg [2:0] sbaccess;       // 0=8-bit,1=16,2=32, etc.
    reg       sbautoincrement;
    reg       sbreadonaddr;
    reg [2:0] sbbusyerror;
    reg       sbbusy;
    reg [6:0] hartsel; 
    reg [3:0] sbversion;
    reg [2:0] cmderr;
    reg       busy;
    reg [4:0] PROGBUFSIZE;
    reg [31:0] progbuff [0:14];
    reg [9:0] hartid;

    // DMCONTROL fields
    reg haltreq, resumereq, hartreset, ackhavereset;
    reg hasel;
    reg setresethaltreq, clrresethaltreq;
    // DMSTATUS fields (many tied to signals or constants)
    reg anyhalted, anyunavail;
    reg AUTHENTICATED, AUTHBUSY, HASRESETHALTREQ;
    // Abstract command fields
    reg [7:0]  cmdtype;
    reg [23:0] control;
    reg [15:0] regno;
    reg        write, transfer, postexec, aarpostincrement;
    reg [2:0]  aarsize;
    reg [31:0] data0, data1;
    reg [9:0]  hartsel_base;

    // Version bits
    reg [3:0] VERSION;
    // System bus regs we set as preset or configurable
    initial begin
        // Preset configuration
        sbversion        = 4'b0000;
        sbaccess         = 3'd2;    // support 32-bit by default
        sbautoincrement  = 1'b0;
        sbreadonaddr     = 1'b0;
        sbbusyerror      = 3'd0;
        sbbusy           = 1'b0;
        // Default DM status
        AUTHENTICATED    = 1'b1;
        AUTHBUSY         = 1'b0;
        HASRESETHALTREQ  = 1'b0;    // no halt-on-reset support
        VERSION          = 4'd2;    // v0.13
        anyhalted        = 1'b0;    // assume core initially running
        anyunavail       = 1'b0;
    end

    // DMI access always block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dmi_readdata <= 32'b0;
            haltreq      <= 1'b0;
            resumereq    <= 1'b0;
            hartreset    <= 1'b0;
            ackhavereset <= 1'b0;
            // Reset SB registers
            sbaddress0_reg <= 32'b0;
            sbdata0_reg    <= 32'b0;
            sbbusy         <= 1'b0;
            sbbusyerror    <= 3'b000;
        end else if (dmi_ready && AUTHENTICATED) begin
            case (dmi_address_in)
                // Abstract Data Registers
                7'h04: begin  // abstractdata0
                    if (dmi_read) begin
                        data0 <= dmi_writedata;
                        $display("Wrote abstractdata0: %h", dmi_writedata);
                    end
                    if (dmi_write) dmi_readdata <= data0;
                end
                7'h05: begin  // abstractdata1
                    if (dmi_read) begin
                        data1 <= dmi_writedata;
                        $display("Wrote abstractdata1: %h", dmi_writedata);
                    end
                    if (dmi_write) dmi_readdata <= data1;
                end

                // DMCONTROL (0x10)
                7'h10: begin
                    dmcontrol_tsk(dmi_writedata);
                end

                // DMSTATUS (0x11)
                7'h11: begin
                    if (dmi_write) dmstatus_tsk(); // on read, output status
                end

                // HartInfo (0x12): not implemented fully
                7'h12: begin
                    if (dmi_write) begin
                        $display("hartinfo read (not implemented)");
                        dmi_readdata <= 32'd0;
                    end
                end

                // Halt Summary 1 (0x13) - for >32 harts (not used for 33 harts)
                7'h13: begin
                    if (dmi_write) begin
                        // Could implement grouping of halts
                        dmi_readdata <= 32'd0;
                    end
                end

                // HARTSEL window: optional, skip fully
                7'h14: begin
                    if (dmi_read) begin
                        // hawindowsel write
                        // if (dmi_write) update hawsel (not used)
                        dmi_readdata <= 32'b0;
                    end
                end
                7'h15: begin
                    if (dmi_write) begin
                        // hawindow write
                        // mask hamr bits if needed
                    end
                end

                // AbstractCS (0x16)
                7'h16: begin
                    if (dmi_write) abstractcs_tsk();
                end

                // Command (0x17)
                7'h17: begin
                    if (dmi_read) begin
                        cmdtype <= dmi_writedata[31:24];
                        control <= dmi_writedata[23:0];
                        abstract_command_tsk();
                    end
                end

                // Conf Str Ptr 0 (0x19): not used
                7'h19: begin
                    if (dmi_write) begin
                        // typically R/O, here do nothing
                        dmi_readdata <= 32'd0;
                    end
                end

                // NEXTDM (0x1D)
                7'h1D: begin
                    if (dmi_write) dmi_readdata <= 32'd0; // only one DM
                end

                // Halt Summary 0 (0x40)
                7'h40: begin
                    if (dmi_write) begin
                        // Individual hart summary (for hartsel group)
                        haltsum0_tsk();
                    end
                end

                // System Bus Access Control and Status (SBACS, 0x38)
                7'h38: begin
                    sysbus_sbcs_tsk();
                end

                // System Bus Address 0 (0x39)
                7'h39: begin
                    if (dmi_read) begin
                        // Write to SB address register
                        sbaddress0_reg <= dmi_writedata;
                        $display("SB address0 set to %h", dmi_writedata);
                        // If auto-read on addr is set:
                        if (!sbbusy && sbreadonaddr) begin
                            sbbusy <= 1'b1;
                            // (Here one would trigger a bus read. We simulate by clearing busy immediately.)
                            #1 sbbusy <= 1'b0;
                            $display("SB read at address %h", sbaddress0_reg);
                            if (sbautoincrement) sbaddress0_reg <= sbaddress0_reg + (sbaccess==3'd2 ? 4 : (sbaccess==3'd1 ? 2 : 1));
                        end
                    end
                    if (dmi_write) begin
                        dmi_readdata <= sbaddress0_reg;
                    end
                end

                // System Bus Data 0 (0x3C)
                7'h3C: begin
                    if (dmi_read) begin
                        // Write to SB data register triggers memory write
                        sbdata0_reg <= dmi_writedata;
                        $display("SB write data %h to mem at %h", dmi_writedata, sbaddress0_reg);
                    end
                    if (dmi_write) dmi_readdata <= sbdata0_reg;
                end

                default: begin
                    dmi_readdata <= 32'b0;  // Unhandled addresses return 0
                end
            endcase
        end else begin
            if (~AUTHENTICATED) $display("DM access denied: not authenticated");
            else              $display("DM not ready");
        end
    end

    // --- Task Definitions ---

    // DMCONTROL Task: handle read/write of DMCONTROL register
    task dmcontrol_tsk;
        input [31:0] data;
        begin
            if (dmi_read) begin
                // Host wrote to DMCONTROL: update internal fields from 'data'
                // Only one of haltreq, resumereq, hartreset, ackhavereset may be 1 per write
                if (data[31]) begin
                    haltreq <= 1;
                    resumereq <= 0;
                end
                if (data[30]) begin
                    resumereq <= 1;
                    haltreq <= 0;
                end
                // Note: If both bits 31 and 30 zero, no change in halt/resume
                hartreset <= data[29];       // optional hart reset
                if (data[29]) haveackrst <= 1;
                if (data[28]) begin
                    ackhavereset <= 1;
                    // Clear any hart-reset flags if we had them
                    // (not modeled further here)
                end
                hasel       <= data[26];
                hartsel_lo  <= data[25:16];
                hartsel_hi  <= data[15:6];
                hartsel     <= {hartsel_hi, hartsel_lo[9:0]};
                setresethaltreq <= data[3] & HASRESETHALTREQ;
                clrresethaltreq <= data[2] & HASRESETHALTREQ;
            end
            if (dmi_write) begin
                // Host reading DMCONTROL: place current values in output
                dmi_readdata <= 32'b0;
                dmi_readdata[31] <= haltreq;
                dmi_readdata[30] <= resumereq;
                dmi_readdata[29] <= hartreset;
                dmi_readdata[28] <= ackhavereset;
                dmi_readdata[26] <= hasel;
                dmi_readdata[25:16] <= hartsel_lo;
                dmi_readdata[15:6] <= hartsel_hi;
                dmi_readdata[3] <= setresethaltreq;
                dmi_readdata[2] <= clrresethaltreq;
                // NDmreset/DMactive not handled (preset to 0)
            end
        end
    endtask

    // DMSTATUS Task: output status fields
    task dmstatus_tsk;
        begin
            dmi_readdata <= 32'b0;
            // Common DMSTATUS fields (some hardwired or computed)
            dmi_readdata[9]  <= 0;  // anyhalted (we assume only hart0, use anyhalted)
            dmi_readdata[8]  <= anyhalted;
            dmi_readdata[15] <= anyunavail;
            // ackhavereset and have reset bits (we preset 0)
            dmi_readdata[19] <= allhavereset;  // (not simulated)
            dmi_readdata[18] <= anyhavereset;
            // autoselect ack/resetc
            dmi_readdata[17] <= anyresumeack;
            dmi_readdata[16] <= anyresumeack;
            // authentication status
            dmi_readdata[7] <= AUTHENTICATED;
            dmi_readdata[6] <= AUTHBUSY;
            // version
            dmi_readdata[3:0] <= VERSION;
        end
    endtask

    // Abstract Control and Status (0x16)
    task abstractcs_tsk;
        begin
            if (dmi_write) begin
                // Read abstractCS
                dmi_readdata <= 32'b0;
                dmi_readdata[28:24] <= PROGBUFSIZE;
                dmi_readdata[12]    <= busy;
                dmi_readdata[3:0]   <= 4'd2; // datacount (2 for data0/data1)
                // cmderr encoding
                if (!busy) begin
                    case (cmderr)
                        3'd1: dmi_readdata[10:8] <= 3'b001;
                        3'd2: dmi_readdata[10:8] <= 3'b010;
                        3'd3: dmi_readdata[10:8] <= 3'b011;
                        3'd4: dmi_readdata[10:8] <= 3'b100;
                        3'd5: dmi_readdata[10:8] <= 3'b101;
                        3'd7: dmi_readdata[10:8] <= 3'b111;
                        default: dmi_readdata[10:8] <= 3'b000;
                    endcase
                end else begin
                    dmi_readdata[10:8] <= cmderr;
                end
            end
        end
    endtask

    // Abstract Command (0x17)
    task abstract_command_tsk;
        begin
            if (!busy) begin
                busy = 1;
                cmderr = 3'd0; // default no error
                // Parse the command fields
                regno  = control[15:0];
                write  = control[16];
                transfer = control[17];
                postexec = control[18];
                aarpostincrement = control[19];
                aarsize = control[22:20];
                // Only 32-bit register access supported
                if (cmdtype == 8'd0) begin  // Access Register
                    if (aarsize == 3'd2) begin
                        $display("Access register [%h]", regno);
                        // (Actual register access not modeled here)
                        // For example: if (transfer) dmi_readdata <= regfile[regno];
                    end else begin
                        cmderr = 3'd4;  // unsupported size
                    end
                end else begin
                    cmderr = 3'd2;  // unsupported command
                end
                busy = 0;
            end else begin
                // Cannot accept new command if busy
                cmderr = 3'd1;
            end
        end
    endtask

    // SB Access Control and Status (0x38)
    task sysbus_sbcs_tsk;
        begin
            if (dmi_read) begin
                // Write to sbcs: update control fields
                if (sbbusy) begin
                    sbbusyerror <= 3'b001;  // busy error
                end else begin
                    sbreadonaddr    <= dmi_writedata[0];
                    sbautoincrement <= dmi_writedata[1];
                    sbaccess        <= dmi_writedata[4:2];
                    // sbbusyerror, sbbusy are cleared/written below
                end
            end
            if (dmi_write) begin
                // Read sbcs: output status bits
                dmi_readdata <= 32'b0;
                dmi_readdata[31:29] <= sbversion;    // version
                dmi_readdata[28:26] <= {1'b0, sbbusy, sbreadonaddr};
                dmi_readdata[25]    <= sbautoincrement;
                dmi_readdata[24:22] <= sbaccess;
                dmi_readdata[21:19] <= sbbusyerror;
                dmi_readdata[18:0]  <= 0;
                // Clear error on read-with-1 (W1C in spec)
                if (dmi_readdata[22]) sbbusyerror <= 3'b000;
            end
        end
    endtask

    // Halt Summary 0 (individual harts in selected group)
    task haltsum0_tsk;
        reg [31:0] sum;
        integer i;
        begin
            sum = 32'b0;
            hartsel_base = {hartsel_hi, hartsel_lo[9:0]};
            for (i = 0; i < 32; i = i + 1) begin
                hartid = hartsel_base + i;
                sum[i] = (hartid == 10'd0) ? anyhalted : 1'b0;
            end
            dmi_readdata <= sum;
        end
    endtask

endmodule
