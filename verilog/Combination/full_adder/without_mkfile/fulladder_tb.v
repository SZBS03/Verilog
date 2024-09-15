module fulladder_tb();
   reg  a_tb;
   reg  b_tb;
   reg  cin_tb;

   wire sum_tb;
   wire carry_tb;

   fulladder u_fulladder(
      .a(a_tb),
      .b(b_tb),
      .cin(cin_tb),
      .sum(out_1_tb),
      .carry(out_2_tb)
   );

   initial begin
    a_tb = 0;
    b_tb = 0;
    cin_tb =0;
    #5;
    a_tb = 0;
    b_tb = 0;
    cin_tb = 1;
    #5;
    a_tb = 0;
    b_tb = 1;
    cin_tb = 0;
    #5;
    a_tb = 0;
    b_tb = 1;
    cin_tb = 1;
    #5;
   end

   initial begin
    $dumpfile("fulladder.vcd");
    $dumpvars(0,fulladder_tb);
   end

endmodule    
