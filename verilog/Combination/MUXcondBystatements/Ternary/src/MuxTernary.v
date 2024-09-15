module mux(
  input wire x0,
  input wire x1,
  input wire x2,
  input wire x3,
  input wire c0,
  input wire c1,

  output reg m
);

   always @(*) begin

    m = (c0 == 0 && c1 == 0) ? x0 :
        (c0 == 0 && c1 == 1) ? x1 :
        (c0 == 1 && c1 == 0) ? x2 :
        (c0 == 1 && c1 == 1) ? x3 : 0;
        
end


endmodule