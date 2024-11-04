module alu(
  input wire [31:0]a,
  input wire [31:0]b,
  input wire [5:0]opcode,
  output reg [31:0]c
);

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
        6'd26: c = a | c;
        6'd27: c = a & b;
        default: c = 32'b0;
        endcase
  end
endmodule