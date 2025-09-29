`ifndef SEQ_SIMPLE_SVH
`define SEQ_SIMPLE_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class seq_simple extends uvm_sequence#(alu_tr);
  `uvm_object_utils(seq_simple)

  function new(string name = "seq_simple"); super.new(name); endfunction

  task body();
    alu_tr tr;
    // a few directed ops
    for (int i=0;i<3;i++) begin
      tr = alu_tr::type_id::create($sformatf("tr_%0d", i));
      tr.op = 3'b001; // ADD
      tr.a = $urandom_range(0,15);
      tr.b = $urandom_range(0,15);
      start_item(tr);
      finish_item(tr);
      `uvm_info("SEQ","issued directed add", UVM_LOW)
      #5ns;
    end
  endtask
endclass

`endif
