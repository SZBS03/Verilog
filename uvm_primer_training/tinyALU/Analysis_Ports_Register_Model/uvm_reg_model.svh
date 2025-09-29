`ifndef UVM_REG_MODEL_SVH
`define UVM_REG_MODEL_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"
`include "../Object_Oriented_Programming_OOP_Transactions/seq_item.svh"

class tinyalu_regmap extends uvm_reg_block;
  `uvm_component_utils(tinyalu_regmap)

  uvm_reg reg_a;
  uvm_reg reg_b;
  uvm_reg reg_op;
  uvm_reg reg_result;

  function new(string name = "tinyalu_regmap");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    reg_a = uvm_reg::type_id::create("reg_a", this);
    reg_b = uvm_reg::type_id::create("reg_b", this);
    reg_op = uvm_reg::type_id::create("reg_op", this);
    reg_result = uvm_reg::type_id::create("reg_result", this);

    reg_a.add_field(.name("A"), .lsb_pos(0), .size(8), .access("RW"), .reset(0));
    reg_b.add_field(.name("B"), .lsb_pos(0), .size(8), .access("RW"), .reset(0));
    reg_op.add_field(.name("OP"), .lsb_pos(0), .size(3), .access("RW"), .reset(0));
    reg_result.add_field(.name("RES"), .lsb_pos(0), .size(16), .access("RO"), .reset(0));

    this.add_reg(reg_a, 'h0);
    this.add_reg(reg_b, 'h4);
    this.add_reg(reg_op, 'h8);
    this.add_reg(reg_result, 'hc);
  endfunction
endclass

`endif
