`ifndef ANALYSIS_FIFO_EXAMPLE_SVH
`define ANALYSIS_FIFO_EXAMPLE_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class fifo_example extends uvm_component;
  `uvm_component_utils(fifo_example)

  uvm_tlm_analysis_fifo#(alu_tr) afifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    afifo = new("afifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr t;
    forever begin
      afifo.get(t);
      `uvm_info("FIFO", $sformatf("Got tr from fifo: op=%0d a=%0h b=%0h result=%0h", t.op, t.a, t.b, t.result), UVM_LOW)
    end
  endtask
endclass

`endif
