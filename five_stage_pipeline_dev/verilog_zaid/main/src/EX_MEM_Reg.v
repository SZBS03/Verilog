module EXMEMRegister(
input wire clk,
input wire [31:0]c,
input wire [31:0]opB,
input wire IDEX_WriteBack,
input wire [1:0] IDEX_AluOP_2,
input wire IDEX_MemoryRead,
input wire IDEX_MemoryWrite,
input wire [4:0] IDEX_rd,
input wire [31:0] IDEX_U_UJ_Load_val,
input wire IDEX_U_UJ_Load,

output reg [31:0] EXMEM_AluRES,
output reg [31:0] rs2,
output reg EXMEM_WriteBack,
output reg EXMEM_MemoryRead,
output reg EXMEM_MemoryWrite,
output reg [4:0]EXMEM_rd,
output reg [1:0]EXMEM_AluOP_2,
output reg [31:0] EXMEM_U_UJ_Load_val,
output reg  EXMEM_U_UJ_Load
);

reg [31:0] EXMEM [0:8];

always @(posedge clk ) begin
    //read 
    EXMEM [0] = c;
    EXMEM [1] = opB;
    EXMEM [2] = IDEX_WriteBack;
    EXMEM [3] = IDEX_MemoryRead;
    EXMEM [4] = IDEX_MemoryWrite;
    EXMEM [5] = IDEX_rd;
    EXMEM [6] = IDEX_AluOP_2;
    EXMEM [7] = IDEX_U_UJ_Load_val;
    EXMEM [8] = IDEX_U_UJ_Load;
    //write 
    EXMEM_AluRES <= EXMEM [0];
    rs2 <= EXMEM [1];
    EXMEM_WriteBack <= EXMEM [2];
    EXMEM_MemoryRead <= EXMEM [3];
    EXMEM_MemoryWrite <= EXMEM [4];
    EXMEM_rd <= EXMEM [5];
    EXMEM_AluOP_2 <= EXMEM [6];
    EXMEM_U_UJ_Load_val <= EXMEM [7];
    EXMEM_U_UJ_Load <= EXMEM [8];
end

endmodule