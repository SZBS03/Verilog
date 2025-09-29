`ifndef SYSTEM_TEST_SVH
`define SYSTEM_TEST_SVH
import uvm_pkg::*;
`include "../Parameterized_Class_Definitions_Env/uvm_env.svh"
`include "../UVM_Agents_VirtualSequences/virtual_seq.svh"

class system_test extends uvm_test;
  `uvm_component_utils(system_test)
  alu_env env;
  virtual_sequencer vseqr;

  function new(string name="system_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env = alu_env::type_id::create("env", this);
    vseqr = virtual_sequencer::type_id::create("vseqr", this);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info("SYSTEST","Running integrated system test", UVM_LOW)
    virtual_sequence vseq = virtual_sequence::type_id::create("vseq");
    vseq.vseqr = vseqr;
    vseq.start(null);
    #5000ns;
  endtask
endclass

`endif
