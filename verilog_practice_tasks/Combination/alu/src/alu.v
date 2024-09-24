module alu(
  input wire [3:0]a,
  input wire [3:0]b,
  input wire [2:0]sel,

  output reg [3:0]c
);
  
  always @(*) begin
    case(sel)
        3'b000: c = a & b;
        3'b001: c = !(a & b);
        3'b010: c = a | b;
        3'b011: c = a ^ b;
        3'b100: c = !(a | b);
        3'b101: c = !(a ^ b);
        3'b110: c = a + b;
        3'b111: c = a - b;
        default: c = 4'b0000;
    endcase
  end
endmodule