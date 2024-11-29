module ControlDecoder_tb();
    reg [31:0] instruction;
    wire [31:0] imm_gen_inst;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire regWrite;
    wire memToReg;
    wire memWrite;
    wire operandA;
    wire operandB;
    wire branch;
    wire [5:0] aluOP;
    wire jalrEN;
    wire jalEN;

    ControlDecoder u_ControlDecoder(
        .instruction(instruction),
        .imm_gen_inst(imm_gen_inst),
        .rs1(rs1),
        .rd(rd),
        .rs2(rs2),
        .regWrite(regWrite),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .operandA(operandA),
        .operandB(operandB),
        .branch(branch),
        .aluOP(aluOP),
        .jalEN(jalEN),
        .jalrEN(jalrEN)
    );

    initial begin
        instruction = 32'h00400093;
        #20;
        instruction = 32'h00500113;
        #20;
        instruction = 32'h40110233;
        #20;
        instruction = 32'h001172B3;
        #20;
        instruction = 32'h0030A313;
        #20;
        instruction = 32'h001121B3;
        #50;
    end

    initial begin
        $dumpfile("./temp/control_decoder_tb.vcd");
        $dumpvars(0, ControlDecoder_tb);
    end
endmodule
