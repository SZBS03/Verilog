`ifndef ALU_SEQUENCER_SVH
`define ALU_SEQUENCER_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class alu_sequencer extends uvm_sequencer#(alu_tr);
  `uvm_component_utils(alu_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

`endif
