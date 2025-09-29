`ifndef FACTORY_OVERRIDE_SVH
`define FACTORY_OVERRIDE_SVH
import uvm_pkg::*;
`include "../Static_Methods_and_Variables_Monitor_Scoreboard/alu_monitor.svh"

class verbose_monitor extends alu_monitor;
  `uvm_component_utils(verbose_monitor)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      @(posedge vif.clk);
      if (vif.done) begin
        tr = alu_tr::type_id::create("tr");
        tr.op = vif.op; tr.a = vif.a; tr.b = vif.b; tr.result = vif.result;
        tr.timestamp = $time;
        `uvm_info("VERBOSE_MON", $sformatf("Observed transaction: op=%0d a=%0h b=%0h res=%0h ts=%0t", tr.op, tr.a, tr.b, tr.result, tr.timestamp), UVM_MEDIUM)
        analysis_port.write(tr);
      end
    end
  endtask
endclass

`endif
