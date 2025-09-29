`ifndef COVERAGE_MODEL_SVH
`define COVERAGE_MODEL_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class alu_coverage extends uvm_subscriber#(alu_tr);
  `uvm_component_utils(alu_coverage)

  int add_count;
  int mul_count;
  int xor_count;
  int and_count;

  function new(string name = "alu_coverage", uvm_component parent = null);
    super.new(name, parent);
    add_count = 0; mul_count = 0; xor_count = 0; and_count = 0;
  endfunction

  function void write(alu_tr t);
    case (t.op)
      3'b001: add_count++;
      3'b100: mul_count++;
      3'b011: xor_count++;
      3'b010: and_count++;
      default: ;
    endcase
  endfunction

  function void report(string s = "");
    `uvm_info("COV", $sformatf("Coverage: add=%0d mul=%0d xor=%0d and=%0d", add_count, mul_count, xor_count, and_count), UVM_LOW)
  endfunction
endclass

`endif
