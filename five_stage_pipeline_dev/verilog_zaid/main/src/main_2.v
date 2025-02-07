`include "src/fetch_stage.v"
`include "src/IF_ID_Reg.v"


module main_2(
    input wire clk,
    input wire PCWrite,
    input wire IF_flush,
    input wire IFIDWrite,
    output wire [31:0] PC,
    output wire [31:0] instruction,
    output wire [31:0] nextinst,
    output wire [31:0] nextPC
);
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

endmodule
