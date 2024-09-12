module buffer_tb();
   reg [1:0]a_tb;
   reg en_tb;
   wire[1:0] b_tb;
    
   buffer u_buffer0(
    .a(a_tb),
    .b(b_tb),
    .en(en_tb)
   );

   initial begin
        a_tb = 2'b10;
        en_tb  =   1'b1;
        #5;
        a_tb = 2'b10;
        en_tb  =   1'b0;
        #5;
   end

   initial begin
    $dumpfile("buffer.vcd");
    $dumpvars(0,buffer_tb);
   end

endmodule