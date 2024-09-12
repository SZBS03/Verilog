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
    case(c0,c1){
        (0,0):
        m = x0;
        (0,1):
        m = x1;
        (1,0):
        m = x2;
        (1,1):
        m = x3;}
    endcase
    
  end
endmodule