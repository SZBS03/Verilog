`include "src/fetch_stage.v"
`include "src/IF_ID_Reg.v"
`include "src/decode_stage.v"

module main_2(
    input wire clk,
);

    wire IFIDWrite, PCWrite, IF_flush, WriteBack, IDEX_MemoryRead, MemoryRead, MemoryWrite, AluSrc, Execution;
    wire [2:0] aluOP_2;
    wire [3:0] aluOP;
    wire [4:0] IDEX_rd , IFID_rs1, IFID_rs2, IFID_rd;
    wire [31:0] MEMEX_WriteBack, IFID_imm, IFID_read_data1, IFID_read_data2, branchPC, PC, instruction, nextinst, nextPC;

    // Instantiate fetch_stage
    fetch_stage u_fetch_stage(
        .PCWrite(PCWrite),
        .clk(clk),
        .PC(PC),
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
        .WriteBack(WriteBack),
        .MemoryRead(MemoryRead),
        .MemoryWrite(MemoryWrite),
        .aluOP(aluOP),
        .aluOP_2(aluOP_2),
        .AluSrc(AluSrc),
        .PCWrite(PCWrite),
        .IFIDWrite(IFIDWrite),
        .IF_flush(IF_flush),
        .Execution(Execution)
    );

endmodule
