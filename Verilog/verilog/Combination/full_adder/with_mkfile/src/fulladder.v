module fulladder(
  input wire a,
  input wire b,
  input wire cin,

  output wire sum,
  output wire carry

);
 wire s1,c1,c2;

halfadder u_halfadder1(
  .a(a),
  .b(b),
  .sum(s1),
  .carry(c2)
);

halfadder u_halfadder2(
  .a(s1),
  .b(cin),
  .sum(sum),
  .carry(c1)
);

assign carry = c1 | c2;

endmodule