module alu(
    input wire [31:0]a,
    input wire [31:0]b,
    input wire [3:0]aluOP,
    output reg [31:0]c
);

always @(*) begin
        case(aluOP) 
        4'd0: c = a & b;
        4'd1: c = a || b;
        4'd2: c = $signed(a) + $signed(b);
        4'd3: c = $signed(a) - $signed(b);
        4'd4: c = $signed(a) < $signed(b);
        4'd5: c = a < b;
        4'd6: c = a ^ b;
        4'd8: c = a << b;
        4'd9: c = $signed(a) >>> $signed(b);
        4'd10: c = a >> b;
        default: c = 32'b0;
        endcase
  end
endmodule