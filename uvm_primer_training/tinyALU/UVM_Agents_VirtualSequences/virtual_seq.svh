`ifndef VIRTUAL_SEQ_SVH
`define VIRTUAL_SEQ_SVH
import uvm_pkg::*;
`include "../UVM_Environments_Sequencer_Sequence/alu_sequencer.svh"
`include "../UVM_Reporting_Sequences/random_sequence.svh"
`include "../UVM_Reporting_Sequences/seq_fibonacci.svh"

class virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)
  alu_sequencer alu_seqr;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass

class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)
  virtual_sequencer vseqr;

  function new(string name="virtual_sequence"); super.new(name); endfunction

  task body();
    random_sequence rand_seq = random_sequence::type_id::create("rand_seq");
    fibonacci_seq fib_seq = fibonacci_seq::type_id::create("fib_seq");
    rand_seq.start(vseqr.alu_seqr);
    fib_seq.start(vseqr.alu_seqr);
  endtask
endclass

`endif
