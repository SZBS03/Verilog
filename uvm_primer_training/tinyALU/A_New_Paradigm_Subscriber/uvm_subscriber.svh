`ifndef ALU_SUBSCRIBER_SVH
`define ALU_SUBSCRIBER_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class alu_subscriber extends uvm_subscriber#(alu_tr);
  `uvm_component_utils(alu_subscriber)

  function new(string name = "alu_subscriber", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void write(alu_tr t);
    `uvm_info("SUB", $sformatf("Subscribed tr op=%0d a=%0h b=%0h res=%0h ts=%0t",
               t.op, t.a, t.b, t.result, t.timestamp), UVM_LOW)
  endfunction
endclass

`endif
