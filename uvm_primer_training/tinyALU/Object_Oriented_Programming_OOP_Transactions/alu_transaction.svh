class alu_tr extends uvm_sequence_item;
  rand bit [2:0] op;
  rand bit [7:0] a, b;
  bit [15:0] result;
  time timestamp;

  `uvm_object_utils_begin(alu_tr)
    `uvm_field_int(op, UVM_BIN)
    `uvm_field_int(a, UVM_DEC)
    `uvm_field_int(b, UVM_DEC)
    `uvm_field_int(result, UVM_HEX)
  `uvm_object_utils_end

  function new(string name = "alu_tr"); super.new(name); endfunction
endclass
