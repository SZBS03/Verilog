module MAIN(
    input wire clk,
    input [31:0]dataIN,
    input wire rst,
    input wire en,
    input wire RW,
);
    wire [4:0]counter_address;
    wire [31:0]imm_gen_inst;
    wire [4:0]rs1;
    wire [4:0]rs2;
    wire [4:0]rd;
    wire regWrite;
    wire memToReg;
    wire memWrite;
    wire operandA;
    wire operandB;
    wire branch;
    wire [5:0] aluOP;
    wire jalrEN;
    wire jalEN;
    wire [31:0] write_data;
    wire [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] aluOut;
    wire [31:0] PC;
    wire [31:0] instMemOUT;
    wire [31:0] dataMemOUT;
    wire [31:0] load_write;

counter u_counter(
    .rst(rst),
    .clk(clk),
    .o(PC)
);

assign counter_address = [6:2]PC;

RAM u_RAM(
    .clk(clk),
    .RW(RW),
    .address(counter_address),
    .dataIN(dataIN),
    .dataOUT(instMemOUT)
);

ControlDecoder u_ControlDecode(
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

registerfile o_registerfile(
    .clk(clk),
    .enable(en),
    .reset(rst),
    .write_data(write_data),
    .rd_data(rd),
    .rs1_data(rs1),
    .rs2_data(rs2),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

wire [31:0]OpA = (operandA) ? PC : operandA;
wire [31:0]OpB = (operandB) ? imm_gen_inst : read_data2;
wire readWrite = (memToReg) ? 1 : (memWrite) ? 0 : 0; 

alu u_alu(
    .a(OpA),
    .b(OpB),
    .opcode(aluOP),
    .c(aluOut)
);

RAM u_RAM(
    .clk(clk),
    .RW(readWrite),
    .address(counter_address),
    .dataIN(aluOut),
    .dataOUT(dataMemOUT)
);

DMI u_DMI(
    .load(dataMemOUT),
    .aluOP(aluOP),
    .load_data(load_write)
);

WriteBack u_WriteBack(
    .load_data(load_write),
    .loadEN(memToReg),
    .aluIN(aluOut),
    .rd_data(write_data)
);

endmodule