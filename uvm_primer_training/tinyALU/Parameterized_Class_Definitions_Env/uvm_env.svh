`ifndef ALU_ENV_SVH
`define ALU_ENV_SVH
import uvm_pkg::*;
`include "../Polymorphism_Driver/alu_driver.svh"
`include "../Static_Methods_and_Variables_Monitor_Scoreboard/alu_monitor.svh"
`include "../Static_Methods_and_Variables_Monitor_Scoreboard/uvm_scoreboard.svh"

class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)
  alu_driver driver;
  alu_monitor monitor;
  alu_scoreboard scoreboard;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = alu_driver::type_id::create("driver", this);
    monitor = alu_monitor::type_id::create("monitor", this);
    scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    monitor.analysis_port.connect(scoreboard.in_export);
  endfunction
endclass

`endif
