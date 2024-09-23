module fulladder(
  input wire a,
  input wire b,
  input wire cin,

  output wire sum,
  output wire carry

);
 wire s1,c1,c2;
assign s1 = a ^ b;
assign c1 = s1 & cin;
assign c2 = a & b;
assign sum = s1 ^ cin;
assign carry = c1 | c2;

endmodule