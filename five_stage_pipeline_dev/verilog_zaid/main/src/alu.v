module alu(
  input wire [31:0]a,
  input wire [31:0]b,
  input wire [5:0]opcode,
  output reg [31:0]c
);

  reg temp [31:0];

  always @(*) begin
        case(opcode) 
        6'd5: c = a + b;
        6'd6: c = a << b;
        6'd7: c = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
        6'd8: c = ($unsigned(a) < $unsigned(b) ) ? 32'b1 : 32'b0;
        6'd9: c = a ^ b;
        6'd10: c = a >> b;
        6'd11: c = a >>> b;
        6'd12: c = a | b;
        6'd13: c = a & b;
        6'd18: c = a + b;
        6'd19: c = a - b;
        6'd20: c = a << b;
        6'd21: c = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0;
        6'd22: c = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0;
        6'd23: c = a ^ b; 
        6'd24: c = a >> b; 
        6'd25: c = a >>> b; 
        6'd26: c = a | b;
        6'd27: c = a & b;
        6'd28: c = b;                               //lui
        6'd14 , 6'd35 , 6'd36: c = a + b;          //auipc , jalr , jal  
        6'd29: c [0] = (a == b) ? 1 : 0;                               //BEQ
        6'd30: c [0] = (a != b) ? 1 : 0;                               //BNE
        6'd31: c [0] = (a < b) ? 1 : 0;                                //BLT
        6'd32: c [0] = (a >= b) ? 1 : 0;                               //BGE
        6'd33: c [0] = ($unsigned(a) < $unsigned(b)) ? 1 : 0;         //BLTU
        6'd34: c [0] = ($unsigned(a) >= $unsigned(b)) ? 1 : 0;        //BGEU     
        default: c = 32'b0;
        endcase
  end
endmodule