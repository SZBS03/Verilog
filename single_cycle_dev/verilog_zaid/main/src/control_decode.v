module ControlDecoder(
    input wire [31:0] instruction,
    output reg [31:0] imm_gen_inst,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output reg regWrite,
    output reg memToReg,
    output reg memWrite,
    output reg operandA,
    output reg operandB,
    output reg branch,
    output reg [5:0] aluOP,
    output reg jalrEN,
    output reg jalEN
);

localparam load_Itype = 7'b0000011;
localparam alu_Itype = 7'b0010011;
localparam jalr_Itype = 7'b1100111;
localparam alu_rtype = 7'b0110011; 
localparam store = 7'b0100011; //0100011

// instr decode
wire [6:0] opcode = instruction[6:0];
wire [2:0] func3 = instruction[14:12];
wire [6:0] func7 = instruction[31:25];
reg [11:0] split_inst;

assign rd = instruction[11:7];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];

// Immediate generation logic
always @(*) begin
    case (opcode)
        load_Itype, alu_Itype, jalr_Itype: begin
            imm_gen_inst = {{20{instruction[31]}}, instruction[31:20]};  //Sign extension
        end
        7'd35: begin   
            split_inst [4:0] = instruction [11:7];
            split_inst [11:5] = instruction [31:25];                                                   //store instruction 
            imm_gen_inst = {{20{split_inst[11]}}, split_inst};
        end
        default: begin
            imm_gen_inst = 32'b0;
        end
    endcase
end

// Control decode logic
always @(*) begin
    regWrite = 0;
    memToReg = 0;
    memWrite = 0;
    operandA = 0;
    operandB = 0;
    branch = 0;
    aluOP = 6'd0;
    jalrEN = 0;
    jalEN = 0;

    case (opcode)
        alu_rtype: begin
            case (func3)
                3'd0: aluOP = func7[5] ? 6'd19 : 6'd18;  // SUB or ADD
                3'd1: aluOP = 6'd20;  // SLL
                3'd2: aluOP = 6'd21;  // SLT
                3'd3: aluOP = 6'd22;  // SLTU
                3'd4: aluOP = 6'd23;  // XOR
                3'd5: aluOP = func7[5] ? 6'd25 : 6'd24;  // SRA or SRL
                3'd6: aluOP = 6'd26;  // OR
                3'd7: aluOP = 6'd27;  // AND
            endcase
            regWrite = 1;
        end
        alu_Itype: begin
            case (func3)
                3'd0: aluOP = 6'd5;   // ADDI
                3'd1: aluOP = 6'd6;   // SLLI
                3'd2: aluOP = 6'd7;   // SLTI
                3'd3: aluOP = 6'd8;   // SLTIU
                3'd4: aluOP = 6'd9;   // XORI
                3'd5: aluOP = func7[5] ? 6'd11 : 6'd10;  // SRAI or SRLI
                3'd6: aluOP = 6'd12;  // ORI
                3'd7: aluOP = 6'd13;  // ANDI
            endcase
            regWrite = 1;
            operandA = 1;
        end
        load_Itype: begin
            case (func3)
                3'd0: aluOP = 6'd0;  // LB
                3'd1: aluOP = 6'd1;  // LH
                3'd2: aluOP = 6'd2;  // LW
                3'd3: aluOP = 6'd3;  // LD
                3'd4: aluOP = 6'd4;  // LBU
            endcase
            regWrite = 1;
            memToReg = 1;
            operandA = 1;
        end
        jalr_Itype: begin
            aluOP = 6'd35;  // JALR operation
            regWrite = 1;
            operandA = 1;
        end
        7'd35: begin
            case(func3)
                3'd0: aluOP = 6'd15;  // SB
                3'd1: aluOP = 6'd16;  // SH
                3'd2: aluOP = 6'd17;  // SW
            endcase
                memWrite = 1;
                operandA = 1;
        end
    endcase
end

endmodule
