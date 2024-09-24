module halfadder_tb();
   reg  a_tb;
   reg  b_tb;

   wire sum_tb;
   wire carry_tb;

   halfadder u_halfadder(
      .a(a_tb),
      .b(b_tb),
      .sum(out_1_tb),
      .carry(out_2_tb)
   );

   initial begin
    a_tb = 0;
    b_tb = 0;
    #5;
    a_tb = 0;
    b_tb = 1;
    #5;
    a_tb = 1;
    b_tb = 0;
    #5;
    a_tb = 1;
    b_tb = 1;
    #5;
   end

   initial begin
    $dumpfile("/home/sheikhzaid/MyTasks/Verilog/half_adder/temp/halfadder.vcd");
    $dumpvars(0,halfadder_tb);
   end

endmodule    
