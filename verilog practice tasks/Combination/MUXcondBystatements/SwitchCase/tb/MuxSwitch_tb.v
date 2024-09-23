module mux_tb();
   reg x0_tb;
   reg x1_tb;
   reg x2_tb;
   reg x3_tb;

   reg [1:0]sel_tb;

   wire m_tb;
  
     mux u_mux(
      .x0(x0_tb),
      .x1(x1_tb),
      .x2(x2_tb),
      .x3(x3_tb),
      .sel(sel_tb),
      .m(m_tb)
   );

   initial begin
    sel_tb = 2'b00
    x0_tb = 1;
    x1_tb = 1;
    x2_tb = 0;
    x3_tb = 0;
   
    #5;
    sel_tb = 2'b01
    x0_tb = 1;
    x1_tb = 1;
    x2_tb = 0;
    x3_tb = 0;
    #5;
    sel_tb = 2'b10
    x0_tb = 1;
    x1_tb = 1;
    x2_tb = 0;
    x3_tb = 1;
    #5;
    sel_tb = 2'b11
    x0_tb = 1;
    x1_tb = 1;
    x2_tb = 0;
    x3_tb = 1;
    #5;
   end

   initial begin
    $dumpfile("temp/MuxSwitch.vcd");
    $dumpvars(0,mux_tb);
   end

endmodule