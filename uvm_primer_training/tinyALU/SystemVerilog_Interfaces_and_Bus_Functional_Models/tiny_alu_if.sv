interface tiny_alu_if(input logic clk);
  logic rst_n;
  logic start;
  logic [2:0] op;
  logic [7:0] a, b;
  logic [15:0] result;
  logic done;

  task automatic reset_alu();
    rst_n = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;
    @(posedge clk);
  endtask

  task automatic send_op(input logic [2:0] op_i, input logic [7:0] a_i, input logic [7:0] b_i);
    op <= op_i; a <= a_i; b <= b_i; start <= 1;
    @(posedge clk);
    start <= 0;
    wait (done == 1);
    @(posedge clk);
  endtask
endinterface
