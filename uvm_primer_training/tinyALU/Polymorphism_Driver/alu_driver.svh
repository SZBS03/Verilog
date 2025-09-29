`ifndef ALU_DRIVER_SVH
`define ALU_DRIVER_SVH
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"
import uvm_pkg::*;

class alu_driver extends uvm_driver#(alu_tr);
  `uvm_component_utils(alu_driver)
  virtual tiny_alu_if vif;
  uvm_analysis_port#(alu_tr) driven_port;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual tiny_alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF","virtual interface not found for driver");
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      seq_item_port.get_next_item(tr);
      // drive to DUT via vif
      vif.a <= tr.a;
      vif.b <= tr.b;
      vif.op <= tr.op;
      @(posedge vif.clk);
      vif.start <= 1; @(posedge vif.clk); vif.start <= 0;
      wait (vif.done == 1);
      tr.result = vif.result;
      seq_item_port.item_done();
      if (driven_port != null) driven_port.write(tr);
      `uvm_info("DRIVER","transaction driven", UVM_LOW)
    end
  endtask
endclass
`endif
