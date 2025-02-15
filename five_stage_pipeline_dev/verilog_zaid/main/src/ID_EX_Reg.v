module IDEXRegister(
    input wire clk,

    input wire [4:0] IFID_rs1,
    input wire [4:0] IFID_rs2,
    input wire [4:0] IFID_rd,
    input wire [31:0] IFID_imm,
    input wire [31:0] IFID_read_data1,
    input wire [31:0] IFID_read_data2,
    input wire IFID_WriteBack,
    input wire IFID_MemoryRead,
    input wire IFID_MemoryWrite,
    input wire IFID_Execution,
    input wire [1:0] IFID_aluOP_2,
    input wire [3:0] IFID_aluOP,
    input wire IFID_AluSrc,
    input wire [31:0] IFID_U_UJ_Load_val,
    input wire IFID_U_UJ_Load,

    output reg [4:0] IDEX_rs1,
    output reg [4:0] IDEX_rs2,
    output reg [4:0] IDEX_rd,
    output reg [31:0] IDEX_imm,
    output reg [31:0] IDEX_read_data1,
    output reg [31:0] IDEX_read_data2,
    output reg IDEX_WriteBack,
    output reg IDEX_MemoryRead,
    output reg IDEX_MemoryWrite,
    output reg IDEX_Execution,
    output reg [1:0] IDEX_aluOP_2,
    output reg [3:0] IDEX_aluOP,
    output reg IDEX_AluSrc,
    output reg [31:0] IDEX_U_UJ_Load_val,
    output reg IDEX_U_UJ_Load
);

    reg [31:0] IDEX [0:14]; 

    always @(posedge clk) begin 
        //read
        IDEX [0] = IFID_WriteBack;
        IDEX [1] = IFID_MemoryRead;
        IDEX [2] = IFID_MemoryWrite;
        IDEX [3] = IFID_Execution;
        IDEX [4] = IFID_rs1;
        IDEX [5] = IFID_rs2;
        IDEX [6] = IFID_rd;
        IDEX [7] = IFID_imm;
        IDEX [8] = IFID_read_data1;
        IDEX [9] = IFID_read_data2;
        IDEX [10] = IFID_aluOP;
        IDEX [11] = IFID_aluOP_2;
        IDEX [12] = IFID_AluSrc;
        IDEX [13] = IFID_U_UJ_Load_val;
        IDEX [14] = IFID_U_UJ_Load;
        
        //write
        IDEX_WriteBack <= IDEX [0];
        IDEX_MemoryRead <= IDEX [1];
        IDEX_MemoryWrite <= IDEX [2];
        IDEX_Execution <= IDEX [3];
        IDEX_rs1 <= IDEX [4];
        IDEX_rs2 <= IDEX [5];
        IDEX_rd <= IDEX [6];
        IDEX_imm <= IDEX [7];
        IDEX_read_data1 <= IDEX [8];
        IDEX_read_data2 <= IDEX [9];
        IDEX_aluOP <= IDEX [10];
        IDEX_aluOP_2 <= IDEX [11];
        IDEX_AluSrc <= IDEX [12];
        IDEX_U_UJ_Load_val <= IDEX [13];
        IDEX_U_UJ_Load <= IDEX [14];

    end

endmodule
