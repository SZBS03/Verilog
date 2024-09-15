module concat_tb();
   reg [1:0]a_tb;
   reg [1:0]b_tb;
   wire[2:0] c_tb;
    
   concat u_concat0(
    .a(a_tb),
    .b(b_tb),
    .c(c_tb)
   );

   initial begin
    a_tb = 2'b10;
    b_tb = 2'b11;
    #5;
    a_tb = 2'b01;
    b_tb = 2'b00;
    #5;
    a_tb = 2'b10;
    b_tb = 2'b01;
    #5;
   end

   initial begin
    $dumpfile("concat.vcd");
    $dumpvars(0,concat_tb);
   end

endmodule