module ControlDecoder(
    input wire [31:0]instruction,
    output reg [31:0]imm_gen_inst,
    output reg [4:0]rs1,
    output reg [4:0]rs2,
    output reg [4:0]rd,
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

wire [6:0]opcode;
wire [2:0]func3;
wire [6:0]func7;

//decode intruction set by parts
assign opcode = [6:0]instruction;
assign rd = [11:7]instruction;
assign func3 = [14:12]instruction;
assign rs1 = [19:15]instruction;
assign rs2 = [24:20]instruction;
assign func7 = [31:25]instruction;

//immidiate generation logic
wire signed [12:0] inst_split;
wire signed [31:0] signed_value;
always @(*) begin
    if(load_Itype or alu_Itype or jalr_Itype) begin
        assign inst_split = [31:20]instruction;
        assign signed_value = $signed{{20{inst_split[11]}},inst_split};
        imm_gen_inst = signed_value;
    end
    else begin
        imm_gen_inst = 32'b0;
    end
end

//control decode logic 
wire func7Split
assign func7Split = [6:5]func7;
always @(*) begin
    case(opcode) 
        alu_rtype: begin
        case(func3)
            3'd0:
                if(~func7Split) aluOP = 6'd18;
                else aluOP = 6'd19;
            3'd1: aluOP = 6'd20;
            3'd2: aluOP = 6'd21;
            3'd3: aluOP = 6'd22;
            3'd4: aluOP = 6'd23;
            3'd5: 
                if(~func7Split) aluOP = 6'd24;
                else aluOP = 6'd25;
            3'd6: aluOP = 6'd26;
            3'd7: aluOP = 6'd27;
        endcase
        regWrite = 1;
        operandA = 0;
        operandB = 0;
        memToReg = 0;
        memWrite = 0;
        branch = 0;
        end
        alu_Itype: begin
        case(func3)
            3'd0: aluOP = 6'd5;
            3'd1: aluOP = 6'd6;
            3'd2: aluOP = 6'd7;
            3'd3: aluOP = 6'd8;
            3'd4: aluOP = 6'd9;
            3'd5: 
            if(~func7Split) aluOP = 6'd10;
            else aluOP = 6'd11;
            3'd6: aluOP = 6'd12;
            3'd7: aluOP = 6'd13;
        endcase
        regWrite = 1;
        operandA = 1;
        operandB = 0;
        memToReg = 0;
        memWrite = 0;
        branch = 0;
        end
        load_Itype: begin
        case(func3)
            3'd0: aluOP = 6'd0;
            3'd1: aluOP = 6'd1;
            3'd2: aluOP = 6'd2;
            3'd3: aluOP = 6'd3;
            3'd4: aluOP = 6'd4;
        endcase
        regWrite = 1;
        operandA = 1;
        operandB = 0;
        memToReg = 1;
        memWrite = 0;
        branch = 0;
        end
        jalr_Itype: begin 
        aluOP = 6'd35;
        regWrite = 1;
        operandA = 1;
        operandB = 0;
        memToReg = 0;
        memWrite = 0;
        branch = 0;
        end
    endcase
end
endmodule