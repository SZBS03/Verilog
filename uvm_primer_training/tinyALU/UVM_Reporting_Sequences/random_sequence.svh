`ifndef RANDOM_SEQUENCE_SVH
`define RANDOM_SEQUENCE_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class random_sequence extends uvm_sequence#(alu_tr);
  `uvm_object_utils(random_sequence)

  function new(string name = "random_sequence"); super.new(name); endfunction

  task body();
    alu_tr tr;
    for (int i=0;i<100;i++) begin
      tr = alu_tr::type_id::create($sformatf("tr_%0d", i));
      assert(tr.randomize());
      start_item(tr);
      finish_item(tr);
      #5ns;
    end
  endtask
endclass

`endif
