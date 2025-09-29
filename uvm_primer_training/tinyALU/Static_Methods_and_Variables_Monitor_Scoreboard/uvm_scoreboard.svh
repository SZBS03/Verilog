`ifndef UVM_SCOREBOARD_SVH
`define UVM_SCOREBOARD_SVH
`include "../Object_Oriented_Programming_OOP_Transactions/alu_transaction.svh"
import uvm_pkg::*;

class alu_scoreboard extends uvm_component;
  `uvm_component_utils(alu_scoreboard)
  uvm_analysis_export#(alu_tr) in_export;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    in_export = new("in_export", this);
  endfunction

  task run_phase(uvm_phase phase);
    alu_tr tr;
    forever begin
      in_export.get(tr);
      bit [15:0] expected;
      case (tr.op)
        3'b001: expected = tr.a + tr.b;
        3'b010: expected = {8'b0, (tr.a & tr.b)};
        3'b011: expected = {8'b0, (tr.a ^ tr.b)};
        3'b100: expected = tr.a * tr.b;
        default: expected = 16'hxxxx;
      endcase
      if (tr.result !== expected) begin
        `uvm_error("SB", $sformatf("Mismatch: exp=%0h got=%0h (op=%0d a=%0h b=%0h)", expected, tr.result, tr.op, tr.a, tr.b));
      end else begin
        `uvm_info("SB","Match", UVM_LOW)
      end
    end
  endtask
endclass

`endif
