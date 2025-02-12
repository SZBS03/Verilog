`include "src/forwarding_unit.v"
`include "src/alu.v"

module execution_stage(
    input wire [4:0] IDEX_rs1,
    input wire [4:0] IDEX_rs2,
    input wire [4:0] IDEX_rd,
    input wire [4:0] EXMEM_rd,
    input wire [4:0] MEMWB_rd,
    input wire [31:0] IDEX_imm,
    input wire [31:0] IDEX_read_data1,
    input wire [31:0] IDEX_read_data2,
    input wire [31:0] EXMEM_AluRES,
    input wire [31:0] MEMWB_AlURES,
    input wire IDEX_WriteBack,
    input wire EXMEM_WriteBack,
    input wire MEMWB_WriteBack,
    input wire IDEX_MemoryRead,
    input wire IDEX_MemoryWrite,
    input wire IDEX_Execution,
    input wire [1:0] IDEX_aluOP_2,
    input wire [3:0] IDEX_aluOP,
    input wire IDEX_AluSrc,
    output reg [31:0]c
);

reg [31:0]a;
reg [31:0]b;
reg [1:0] forwardA;
reg [1:0] forwardB;


//forwarding unit
forwarding_unit u_forwarding_unit(
    .IDEX_rs1(IDEX_rs1),
    .IDEX_rs2(IDEX_rs2),
    .EXMEM_rd(EXMEM_rd),
    .MEMWB_rd(MEMWB_rd),
    .EXMEM_WriteBack(EXMEM_WriteBack),
    .MEMWB_WriteBack(MEMWB_WriteBack),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

always @(*) begin
    case (forwardA):
        2'b00: a = IDEX_read_data1;
        2'b01: a = EXMEM_AluRES;
        2'b10: a = MEMWB_AluRES;
    endcase 

    case (forwardB):
        2'b00: b = IDEX_read_data1;
        2'b01: b = EXMEM_AluRES;
        2'b10: b = MEMWB_AluRES;
    endcase 
end


//alu operation
alu u_alu(
    .a(a),
    .b(b),
    .aluOP(IDEX_aluOP),
    .c(c)
);


endmodule