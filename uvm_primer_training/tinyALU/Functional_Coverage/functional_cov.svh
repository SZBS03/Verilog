`ifndef FUNCTIONAL_COV_SVH
`define FUNCTIONAL_COV_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class alu_cov_sub extends uvm_subscriber#(alu_tr);
  `uvm_component_utils(alu_cov_sub)

  alu_tr tr;

  covergroup cg_op @(posedge clk);
    option.per_instance = 1;
    cp_op : coverpoint tr.op {
      bins add = {3'b001};
      bins andb = {3'b010};
      bins xorb = {3'b011};
      bins mul = {3'b100};
    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name,parent);
    cg_op = new();
  endfunction

  function void write(alu_tr t);
    tr = t;
    cg_op.sample();
  endfunction
endclass

`endif
