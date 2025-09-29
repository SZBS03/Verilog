`ifndef ADD_TEST_SVH
`define ADD_TEST_SVH
import uvm_pkg::*;
`include "../Parameterized_Class_Definitions_Env/uvm_env.svh"

class add_test extends uvm_test;
  `uvm_component_utils(add_test)
  alu_env env;

  function new(string name="add_test", uvm_component parent=null); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info("ADD_TEST","Running add_test (directed)", UVM_LOW)
    #1000ns;
  endtask
endclass

`endif
