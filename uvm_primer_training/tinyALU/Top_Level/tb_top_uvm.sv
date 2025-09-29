`timescale 1ns/1ps
import uvm_pkg::*;

`include "../Parameterized_Class_Definitions_Env/uvm_env.svh"
`include "../Object_Oriented_Programming_OOP_Transactions/seq_item.svh"
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"
`include "../Factory_Pattern_UVM_Tests/random_test.svh"
`include "../Factory_Pattern_UVM_Tests/add_test.svh"

module tb_top_uvm;
  logic clk = 0; always #5 clk = ~clk;
  SystemVerilog_Interfaces_and_Bus_Functional_Models::tiny_alu_if taf(clk);

  //  DUT 
  tiny_alu dut(.clk(clk),
               .rst_n(taf.rst_n),
               .start(taf.start),
               .op(taf.op),
               .a(taf.a),
               .b(taf.b),
               .result(taf.result),
               .done(taf.done));

  initial begin
    // virtual interface for UVM components
    uvm_config_db#(virtual tiny_alu_if)::set(null, "", "vif", taf);
    run_test();
  end
endmodule
