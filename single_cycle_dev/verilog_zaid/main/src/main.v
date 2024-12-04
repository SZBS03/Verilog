module MAIN (
    input wire clk,
    input [31:0] dataIN,
    input wire rst,
    input wire en,
    input wire RW
);
    // Internal Wires
    wire [4:0] counter_address;
    wire [31:0] imm_gen_inst;
    wire [4:0] rs1, rs2, rd;
    wire regWrite, memToReg, memWrite, readWrite , operandA, operandB;
    wire branch, jalrEN, jalEN;
    wire [5:0] aluOP;
    wire [31:0] write_data, read_data1, read_data2;
    wire [31:0] aluOut, PC, instMemOUT, dataMemLoad, load_write , store_data;

    // Fetch Stage
    fetch u_fetch(
        .clk(clk),
        .rst(rst),
        .en(en),
        .counterOUT(PC),
        .mem_address(counter_address),
        .instruction(instMemOUT)
    );

    // Control Decoder
    ControlDecoder u_ControlDecode (
        .instruction(instMemOUT),
        .imm_gen_inst(imm_gen_inst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .regWrite(regWrite),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .operandA(operandA),
        .operandB(operandB),
        .aluOP(aluOP)
    );

    // Register File
    register o_register (
        .clk(clk),
        .reset(rst),
        .regWrite(regWrite),
        .write_data(write_data),
        .rd_data(rd),
        .rs1_data(rs1),
        .rs2_data(rs2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    wire [31:0] OpA;
    wire [31:0] OpB;
    assign OpA = operandA ? imm_gen_inst : read_data1;
    assign OpB = operandB ? PC  : read_data2;
    assign readWrite = (memToReg) ? 1 : (memWrite) ? 0 : -1;
    // ALU
    alu u_alu (
        .a(OpA),
        .b(OpB),
        .opcode(aluOP),
        .c(aluOut)
    );

    // Data Memory (RAM2)
    RAM u_RAM2 (
        .clk(clk),
        .rs1(read_data1),
        .rd(write_data),
        .Immediate(imm_gen_inst),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .MemWrite(store_data),  
        .MemRead(dataMemLoad)
    );

    // Data Memory Interface (DMI)
    DMI u_DMI (
        .load(dataMemLoad),
        .rs2(read_data2),
        .store_data(store_data),
        .aluOP(aluOP),
        .load_data(load_write)
    );

    // Write Back
    assign write_data = memToReg ? load_write : aluOut;
endmodule
