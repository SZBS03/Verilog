module alu_tb();
   reg [3:0]a_tb;
   reg [3:0]b_tb;

   reg [2:0]sel_tb;

   wire [3:0]c_tb;
  
   alu u_alu(
      .a(a_tb),
      .b(b_tb),
      .sel(sel_tb),
      .c(c_tb)
   );

   initial begin
    sel_tb = 3'b000;
    a_tb = 4'b0010;
    b_tb = 4'b0110;
   
    #5;
    sel_tb = 3'b001;
    a_tb = 4'b0001;
    b_tb = 4'b1000;

    #5;
    sel_tb = 3'b010;
    a_tb = 4'b1010;
    b_tb = 4'b0101;

    #5;
    sel_tb = 3'b011;
    a_tb = 4'b1100;
    b_tb = 4'b0110;

    #5;
   end

   initial begin
    $dumpfile("temp/alu.vcd");
    $dumpvars(0,alu_tb);
   end

endmodule