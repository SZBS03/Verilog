`ifndef SEQ_FIBONACCI_SVH
`define SEQ_FIBONACCI_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/seq_item.svh"

class fibonacci_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(fibonacci_seq)

  function new(string name = "fibonacci_seq"); super.new(name); endfunction

  task body();
    seq_item it;
    int a = 0, b = 1;
    for (int i = 0; i < 20; i++) begin
      it = seq_item::type_id::create($sformatf("it_%0d", i));
      it.a = a; it.b = b; it.op = 3'b001;
      start_item(it);
      finish_item(it);
      int tmp = a + b; a = b; b = tmp;
      #10ns;
    end
  endtask
endclass

`endif
