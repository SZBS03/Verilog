class seq_item extends uvm_sequence_item;
  rand bit [2:0] op;
  rand bit [7:0] a, b;
  `uvm_object_utils(seq_item)
  function new(string name = "seq_item"); super.new(name); endfunction
endclass
