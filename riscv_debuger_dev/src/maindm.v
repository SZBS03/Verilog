`include "riscv_debuger_dev/src/dmi.v"
`include "riscv_debuger_dev/src/reg-interface.v"
`include "riscv_debuger_dev/src/sbi-mem.v"
`include "riscv_debuger_dev/src/dmi_regdump.v"
`include "five_stage_pipeline_dev/verilog_zaid/main/src/main_2.v"

module dmi_main #(parameter LEN = 128, WID = 32, NUMBEROFCORES = 33)
(
    input  wire clk,
    input  wire reset
);

    wire haltreq, resumereq;
    wire reg_write, reg_read;
    wire sb_read, sb_write;

    wire [32:0] halted_inputs;
    wire [31:0] reg_wdata, reg_rdata;
    wire [31:0] sb_addr, sb_wdata, sb_rdata;
    wire [4:0]  reg_addr;
    wire [31:0] dmi_rdata;

    wire sb_ready;
    wire [7:0] sb_mem [0:LEN-1];
    wire [7:0] sb_mem_out [0:LEN-1];

    wire [LEN-1:0] sb_wvalid;

    wire rf_we;
    wire [$clog2(WID)-1:0] rf_addr;
    wire [WID-1:0] rf_wdata;
    wire [WID-1:0] rf_rdata;

    wire dmi_wr;
    wire dmi_rd;
    wire [6:0]  dmi_addr;
    wire [31:0] dmi_wdata;

    dmi_regDump u_dmi_regDump(
        .clk(clk),
        .dmi_rd(dmi_rd),
        .dmi_wr(dmi_wr),
        .dmi_addr(dmi_addr),
        .dmi_wdata(dmi_wdata)
    );

    DMI #(.LENGTH(LEN), .NOC(NUMBEROFCORES)) u_DMI (
        .clk(clk),
        .dmi_wr(dmi_wr),
        .dmi_rd(dmi_rd),
        .dmi_addr(dmi_addr),
        .dmi_wdata(dmi_wdata),
        .dmi_rdata(dmi_rdata),
        .haltreq(haltreq),
        .resumereq(resumereq),
        .halted_inputs(halted_inputs),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .reg_write(reg_write),
        .reg_read(reg_read),
        .reg_rdata(reg_rdata),
        .sb_addr(sb_addr),
        .sb_wdata(sb_wdata),
        .sb_rdata(sb_rdata),
        .sb_read(sb_read),
        .sb_write(sb_write),
        .sb_ready(sb_ready)
    );

    regfile_interface #(.WIDTH(WID)) u_regfile_interface (
        .clk(clk),
        .rst(reset),
        .reg_read(reg_read),
        .reg_write(reg_write),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .reg_rdata(reg_rdata),
        .rf_we(rf_we),
        .rf_addr(rf_addr),
        .rf_wdata(rf_wdata),
        .rf_rdata(rf_rdata)
    );

    system_bus_memory #(.LENGTH(LEN)) u_system_bus_memory (
        .clk(clk),
        .sb_addr(sb_addr),
        .sb_wdata(sb_wdata),
        .sb_rdata(sb_rdata),
        .sb_read(sb_read),
        .sb_write(sb_write),
        .sb_wvalid(sb_wvalid),
        .sb_ready(sb_ready)
    );

    main #(.L(LEN), .W(WID)) u_main (
        .clk(clk),
        .sb_mem(sb_mem),
        .sb_mem_out(sb_mem_out),
        .sb_ready(sb_ready),
        .haltreq(haltreq),
        .resumereq(resumereq),
        .sb_read(sb_read),
        .sb_write(sb_write),
        .sb_wvalid(sb_wvalid),
        .rf_we(rf_we),
        .rf_addr(rf_addr),
        .rf_wdata(rf_wdata),
        .rf_rdata(rf_rdata)
    );

endmodule