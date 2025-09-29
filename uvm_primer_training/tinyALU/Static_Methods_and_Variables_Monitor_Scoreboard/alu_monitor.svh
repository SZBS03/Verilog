`ifndef ALU_MONITOR_SVH
`define ALU_MONITOR_SVH
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"
import uvm_pkg::*;

class alu_monitor extends uvm_component;
  `uvm_component_utils(alu_monitor)
  uvm_analysis_port#(alu_tr) analysis_port;
  virtual tiny_alu_if vif;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual tiny_alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF","virtual interface not found for monitor");
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      @(posedge vif.clk);
      if (vif.done) begin
        tr = alu_tr::type_id::create("tr");
        tr.op = vif.op; tr.a = vif.a; tr.b = vif.b; tr.result = vif.result;
        tr.timestamp = $time;
        analysis_port.write(tr);
      end
    end
  endtask
endclass

`endif
