module DebugModule(
  input wire [31:0] dmcont_reg,  //at 0x10
  input wire [31:0] dmstat_reg,  //at 0x11    
);
wire [31:0] dmcont_reg_w;

DMcont u_DMcont(
    .dmcont_reg_i(dmcont_reg),
    .dmcont_reg_o(dmcont_reg_w)
);



endmodule