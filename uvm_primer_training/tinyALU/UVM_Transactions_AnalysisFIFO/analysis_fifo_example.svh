`ifndef ANALYSIS_FIFO_EXAMPLE2_SVH
`define ANALYSIS_FIFO_EXAMPLE2_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class analysis_fifo_example extends uvm_component;
  `uvm_component_utils(analysis_fifo_example)
  uvm_tlm_analysis_fifo#(alu_tr) afifo;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    afifo = new("afifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      afifo.get(tr);
      `uvm_info("AFIFO", $sformatf("AFIFO got tr op=%0d a=%0h b=%0h res=%0h", tr.op, tr.a, tr.b, tr.result), UVM_LOW)
    end
  endtask
endclass

`endif
