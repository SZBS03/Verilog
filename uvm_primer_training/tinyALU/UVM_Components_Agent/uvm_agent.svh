`ifndef ALU_AGENT_SVH
`define ALU_AGENT_SVH
import uvm_pkg::*;
`include "../Polymorphism_Driver/alu_driver.svh"
`include "../Static_Methods_and_Variables_Monitor_Scoreboard/alu_monitor.svh"

class alu_agent extends uvm_component;
  `uvm_component_utils(alu_agent)

  alu_driver driver;
  alu_monitor monitor;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = alu_driver::type_id::create("driver", this);
    monitor = alu_monitor::type_id::create("monitor", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
endclass

`endif
