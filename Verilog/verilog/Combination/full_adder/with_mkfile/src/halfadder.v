module halfadder(
  input wire  a,  //or gate input
  input wire b,   //or gate input 

  output wire sum,  //sum 
  output wire carry  //carry  

);

assign sum = a ^ b;
assign carry =  a & b;
  
endmodule