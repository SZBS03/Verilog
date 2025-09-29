`ifndef SCOREBOARD_FIFO_SVH
`define SCOREBOARD_FIFO_SVH
import uvm_pkg::*;
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"

class alu_scoreboard_fifo extends uvm_component;
  `uvm_component_utils(alu_scoreboard_fifo)
  uvm_tlm_analysis_fifo#(alu_tr) mon_fifo;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_fifo = new("mon_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      mon_fifo.get(tr);
      bit [15:0] expected;
      case (tr.op)
        3'b001: expected = tr.a + tr.b;
        3'b010: expected = {8'b0, (tr.a & tr.b)};
        3'b011: expected = {8'b0, (tr.a ^ tr.b)};
        3'b100: expected = tr.a * tr.b;
        default: expected = 16'hxxxx;
      endcase
      if (tr.result !== expected)
        `uvm_error("SBFIFO", $sformatf("Mismatch exp=%0h got=%0h", expected, tr.result))
      else
        `uvm_info("SBFIFO","Match", UVM_LOW)
    end
  endtask
endclass

`endif
