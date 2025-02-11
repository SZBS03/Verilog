`include "src/fetch_stage.v"
`include "src/IF_ID_Reg.v"
`include "src/decode_stage.v"
`include "src/ID_EX_Reg.v"

module main(
    input wire clk
);


    wire IFIDWrite,branch, PCWrite, IF_flush, IFID_WriteBack, IDEX_MemoryRead, IFID_MemoryRead, IFID_MemoryWrite, IFID_AluSrc, IFID_Execution;
    wire [2:0] IFID_aluOP_2, IDEX_aluOP_2;
    wire [3:0] IFID_aluOP, IDEX_aluOP;
    wire [4:0] IDEX_rd, IFID_rs1, IFID_rs2, IFID_rd, IDEX_rs1, IDEX_rs2;
    wire [31:0] MEMEX_WriteBack, IFID_imm, IFID_read_data1, IFID_read_data2, branchPC, PC, instruction, nextinst, nextPC;
    wire [31:0] IDEX_imm, IDEX_read_data1, IDEX_read_data2;
    wire IDEX_WriteBack, IDEX_MemoryWrite, IDEX_Execution, IDEX_AluSrc;

    // Instantiate fetch_stage
    fetch_stage u_fetch_stage(
        .PCWrite(PCWrite),
        .clk(clk),
        .PC(PC),
        .branch(branch),
        .branchPC(branchPC),
        .instruction(instruction)
    );

    // Instantiate IFIDRegister
    IFIDRegister u_IFIDRegister(
        .IF_flush(IF_flush),
        .IFIDWrite(IFIDWrite),
        .PC(PC),
        .instruction(instruction),
        .nextinst(nextinst),
        .nextPC(nextPC),
        .clk(clk) 
    );

    decode_stage u_decode_stage(
        .clk(clk),
        .PC(nextPC),
        .branch(branch),
        .instruction(nextinst),
        .MEMEX_WriteBack(MEMEX_WriteBack),
        .IDEX_MemoryRead(IDEX_MemoryRead),
        .IDEX_rd(IDEX_rd),
        .IFID_rs1(IFID_rs1),
        .IFID_rs2(IFID_rs2),
        .IFID_rd(IFID_rd),
        .IFID_imm(IFID_imm),
        .IFID_read_data1(IFID_read_data1),
        .IFID_read_data2(IFID_read_data2),
        .branchPC(branchPC),
        .WriteBack(IFID_WriteBack),
        .MemoryRead(IFID_MemoryRead),
        .MemoryWrite(IFID_MemoryWrite),
        .aluOP(IFID_aluOP),
        .aluOP_2(IFID_aluOP_2),
        .AluSrc(IFID_AluSrc),
        .PCWrite(PCWrite),
        .IFIDWrite(IFIDWrite),
        .IF_flush(IF_flush),
        .Execution(IFID_Execution)
    );

    IDEXRegister u_IDEXRegister(
        .clk(clk),
        .IFID_rs1(IFID_rs1),
        .IFID_rs2(IFID_rs2),
        .IFID_rd(IFID_rd),
        .IFID_imm(IFID_imm),
        .IFID_read_data1(IFID_read_data1),
        .IFID_read_data2(IFID_read_data2),
        .IFID_WriteBack(IFID_WriteBack),
        .IFID_MemoryRead(IFID_MemoryRead),
        .IFID_MemoryWrite(IFID_MemoryWrite),
        .IFID_Execution(IFID_Execution),
        .IFID_aluOP_2(IFID_aluOP_2),
        .IFID_aluOP(IFID_aluOP),
        .IFID_AluSrc(IFID_AluSrc),

        .IDEX_rs1(IDEX_rs1),
        .IDEX_rs2(IDEX_rs2),
        .IDEX_rd(IDEX_rd),
        .IDEX_imm(IDEX_imm),
        .IDEX_read_data1(IDEX_read_data1),
        .IDEX_read_data2(IDEX_read_data2),
        .IDEX_WriteBack(IDEX_WriteBack),
        .IDEX_MemoryRead(IDEX_MemoryRead),
        .IDEX_MemoryWrite(IDEX_MemoryWrite),
        .IDEX_Execution(IDEX_Execution),
        .IDEX_aluOP_2(IDEX_aluOP_2),
        .IDEX_aluOP(IDEX_aluOP),
        .IDEX_AluSrc(IDEX_AluSrc)
    );



endmodule
