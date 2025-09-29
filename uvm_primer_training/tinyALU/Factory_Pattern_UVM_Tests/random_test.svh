`ifndef RANDOM_TEST_SVH
`define RANDOM_TEST_SVH
import uvm_pkg::*;
`include "../Parameterized_Class_Definitions_Env/uvm_env.svh"
`include "../Object_Oriented_Programming_OOP_Transactions/seq_item.svh"

class random_test extends uvm_test;
  `uvm_component_utils(random_test)
  alu_env env;

  function new(string name="random_test", uvm_component parent=null); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info("RND_TEST","Running random_test (placeholder)", UVM_LOW)
    seq_item it;
    for (int i=0;i<50;i++) begin
      it = seq_item::type_id::create($sformatf("it_%0d",i));
      assert(it.randomize());
      #10ns;
    end
    #2000ns;
  endtask
endclass

`endif
