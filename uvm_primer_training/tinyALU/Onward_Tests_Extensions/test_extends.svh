`ifndef TEST_EXTENDS_SVH
`define TEST_EXTENDS_SVH
import uvm_pkg::*;
`include "../Parameterized_Class_Definitions_Env/uvm_env.svh"
`include "../UVM_Reporting_Sequences/random_sequence.svh"

class directed_test extends uvm_test;
  `uvm_component_utils(directed_test)
  alu_env env;

  function new(string name="directed_test", uvm_component parent=null); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    env = alu_env::type_id::create("env", this);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info("DIRTEST","Running directed test", UVM_LOW)
    random_sequence seq = random_sequence::type_id::create("seq");
    #1000ns;
  endtask
endclass

`endif
