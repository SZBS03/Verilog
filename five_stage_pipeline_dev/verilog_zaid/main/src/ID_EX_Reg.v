module decode_stage(

input wire [4:0] IDEX_rs1,
input wire [4:0] IDEX_rs2,
input wire [4:0] IDEX_rd,
input wire [31:0] IDEX_imm,
input wire [31:0] IDEX_read_data1,
input wire [31:0] IDEX_read_data2,
input wire WriteBack,
input wire MemoryRead,
input wire MemoryWrite,
input wire Execution

output reg [4:0] IDEX_rs1,
output reg [4:0] IDEX_rs2,
output reg [4:0] IDEX_rd,
output reg [31:0] IDEX_imm,
output reg [31:0] IDEX_read_data1,
output reg [31:0] IDEX_read_data2,
output reg WriteBack,
output reg MemoryRead,
output reg MemoryWrite,
output reg Execution
);

    reg [31:0] IDEX [0:9]; 

    always @(posedge clk) begin 
        //read
            IDEX [0] <= WriteBack;
            IDEX [1] <= MemoryRead;
            IDEX [2] <= MemoryWrite;
            IDEX [3] <= Execution;
            IDEX [4] <= IDEX_rs1;
            IDEX [5] <= IDEX_rs2;
            IDEX [6] <= IDEX_rd;
            IDEX [7] <= IDEX_imm;
            IDEX [8] <= IDEX_read_data1;
            IDEX [9] <= IDEX_read_data2;
        //write
            WriteBack <= IDEX [0];
            MemoryRead <= IDEX [1];
            MemoryWrite <= IDEX [2];
            Execution <= IDEX [3];
            IDEX_rs1 <= IDEX [4];
            IDEX_rs2 <= IDEX [5];
            IDEX_rd <= IDEX [6];
            IDEX_imm <= IDEX [7];
            IDEX_read_data1 <= IDEX [8];
            IDEX_read_data2 <= IDEX [9];
    end

endmodule