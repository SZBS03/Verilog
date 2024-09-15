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
    if (c0==0 && c1==0)
      m = x0;
    else if (c0==0 && c1==1)
      m = x1;
    else if (c0==1 && c1==0)
      m = x2;
    else if (c0==1 && c1==1)
      m = x3;
    else
      m=0;
  end
endmodule