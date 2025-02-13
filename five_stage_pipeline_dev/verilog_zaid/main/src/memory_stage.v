module memory_stage(
    input wire clk,
    input wire [1:0] aluOP_2,
    input wire [31:0] EXMEM_AluRES,
    input wire [31:0] rs2,
    input wire EXMEM_MemoryRead,
    input wire EXMEM_MemoryWrite,
    output reg [31:0] EXMEM_LoadData
);

reg [7:0]LB;
reg [15:0]LH;
reg [7:0]LBU;
reg [15:0]LHU;
reg [31:0]LW;

reg [31:0] SW;
reg [15:0] SH;
reg [7:0] SB;
reg [31:0] load_data; //temp reg

integer i;
reg [31:0] DM [0:31];

initial begin
    for (i=0; i<31; i=i+1) begin
        DM [i] = 0;    
    end
end

//Data Memory 
always @(posedge clk ) begin
//default values
SW = 32'bxxxx;
SH = 16'bxxx;
SB = 8'bxx;
load_data = 32'bxxxx;
EXMEM_LoadData = 32'bxxxx;
//store:
if (EXMEM_MemoryWrite) begin
    //store decode
    SW = rs2;
    SH = rs2[15:0];
    SB = rs2[7:0];
    case (aluOP_2)
    2'b00: begin
        DM[EXMEM_AluRES[6:2]] = {24'b0, SB};    // store byte
    end
    2'b01: begin
        DM[EXMEM_AluRES[6:2]] = {16'b0, SH};    // store half word 
    end
    default begin
        DM[EXMEM_AluRES[6:2]] = SW;                         
    end
    endcase
end
//load:
if (EXMEM_MemoryRead) begin
    //load decode
    case (aluOP_2)
    2'b00: begin
        load_data = DM[EXMEM_AluRES[6:2]];  // load byte 
        LB = load_data[7:0];
        EXMEM_LoadData = $signed({{25{LB[7]}},LB});
    end
    2'b01: begin
        load_data = DM[EXMEM_AluRES[6:2]];  // load half word
        LH = load_data[15:0];
        EXMEM_LoadData = $signed({{17{LH[15]}},LH});
    end
    2'b10: begin
        load_data = DM[EXMEM_AluRES[6:2]];  // load byte unsigned
        LBU = load_data[7:0];
        EXMEM_LoadData = $unsigned({24'b0,LBU});
    end
    2'b11: begin
        load_data = DM[EXMEM_AluRES[6:2]];  // load half word signed
        LHU = load_data[15:0];
        EXMEM_LoadData = $unsigned({16'b0, LHU});
    end
    default begin
        EXMEM_LoadData = DM[EXMEM_AluRES[6:2]];  // load word 
    end
    endcase
end
end

endmodule