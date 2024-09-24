module mux(
  input wire x0,
  input wire x1,
  input wire x2,
  input wire x3,
  input wire [1:0]sel,

  output reg m
);
  
  always @(*) begin
    case(sel){
        2'b00:
        m = x0;
        2'b01:
        m = x1;
        2'b10:
        m = x2;
        2'b11:
        m = x3;}
    endcase
    
  end
endmodule