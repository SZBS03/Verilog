`ifndef TB_HELPERS_SVH
`define TB_HELPERS_SVH
import uvm_pkg::*;

function void uvm_do_start_sequence(string seq_name, uvm_component comp);
  uvm_sequence_base seq;
  seq = uvm_factory::create_object_by_name(seq_name);
  if (seq == null) begin
    `uvm_error("TBHELP", $sformatf("Unable to create sequence %s", seq_name))
  end else begin
    `uvm_info("TBHELP", $sformatf("Created sequence %s (manual start not implemented)", seq_name), UVM_LOW)
  end
endfunction

`endif
