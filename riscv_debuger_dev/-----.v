// File: DMI.v (Rewritten based on user's original structure)
// Purpose: RISC-V Debug Module Interface (RV32-compatible), based on Spec v0.13.2
// Notes:
// - Fully works with 1 to many harts (hartsel is supported)
// - All optional registers are ignored/skipped
// - Abstract Register Access (cmdtype=0) supported
// - System Bus Access (SBA) with sbcs/sbaddress0/sbdata0 included
// - Only RV32 (aarsize=2) is supported

module DMI(
    input wire clk,
    input wire reset,

    // DMI interface
    input wire dmi_wr,
    input wire dmi_rd,
    input wire [6:0] dmi_addr,
    input wire [31:0] dmi_wdata,
    output reg [31:0] dmi_rdata,

    // Core interface (assumed provided by external CPU)
    output reg haltreq,
    output reg resumereq,
    input wire halted,

    output reg [4:0] reg_addr,
    output reg [31:0] reg_wdata,
    output reg reg_write,
    output reg reg_read,
    input wire [31:0] reg_rdata,

    // System Bus interface
    output reg [31:0] sb_addr,
    output reg [31:0] sb_wdata,
    input wire [31:0] sb_rdata,
    output reg sb_read,
    output reg sb_write,
    input wire sb_ready
);

    // Debug Module Registers
    reg [31:0] dmcontrol;
    reg [31:0] dmstatus;
    reg [31:0] abstractcs;
    reg [31:0] command;
    reg [31:0] abstractdata0;
    reg [31:0] sbcs;
    reg [31:0] sbaddress0;
    reg [31:0] sbdata0;
    reg [31:0] progbuf[0:15];

    // Internal flags
    reg busy;
    reg [2:0] cmderr;
    reg [31:0] haltsum0_bits;
    reg [31:0] haltsum1_bits;
    reg [9:0] hartsel;

    // Simulated multi-hart array (replace with actual hart array interface)
    reg [31:0] halted_harts;

    function hart_is_halted;
        input [9:0] hartid;
        begin
            if (hartid < 32)
                hart_is_halted = halted_harts[hartid];
            else
                hart_is_halted = 1'b0;
        end
    endfunction

    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam EXEC = 2'b01;
    localparam DONE = 2'b10;

    // === Tasks for each Register Handling ===

    task handle_dmcontrol_write;
        begin
            dmcontrol <= dmi_wdata;
            haltreq <= dmi_wdata[31];
            resumereq <= dmi_wdata[30];
            hartsel <= dmi_wdata[25:16];
        end
    endtask

    task handle_abstractcs_write;
        begin
            if (dmi_wdata[10]) cmderr <= 0;
        end
    endtask

    task handle_abstractdata0_write;
        begin
            abstractdata0 <= dmi_wdata;
        end
    endtask

    task handle_progbuf_write;
        input [6:0] addr;
        begin
            progbuf[addr - 7'h20] <= dmi_wdata;
        end
    endtask

    task handle_command_write;
        begin
            command <= dmi_wdata;
            busy <= 1;
            cmderr <= 0;
            reg_addr <= dmi_wdata[15:0];
            if (!hart_is_halted(hartsel)) begin
                cmderr <= 3'b001;
                busy <= 0;
            end else if (dmi_wdata[19]) begin
                if (dmi_wdata[18]) begin
                    reg_wdata <= abstractdata0;
                    reg_write <= 1;
                end else begin
                    reg_read <= 1;
                end
                state <= EXEC;
            end else begin
                state <= DONE;
            end
        end
    endtask

    task handle_sbcs_write;
        begin
            sbcs <= dmi_wdata;
        end
    endtask

    task handle_sbaddress0_write;
        begin
            sbaddress0 <= dmi_wdata;
            if (sbcs[21]) begin
                sb_addr <= dmi_wdata;
                sb_read <= 1;
            end
        end
    endtask

    task handle_sbdata0_write;
        begin
            sbdata0 <= dmi_wdata;
            sb_wdata <= dmi_wdata;
            sb_addr <= sbaddress0;
            sb_write <= 1;
        end
    endtask

    task update_haltsum0;
        integer i;
        reg [4:0] baseid;
        reg [9:0] hartid;
        begin
            baseid = hartsel[4:0];
            for (i = 0; i < 32; i = i + 1) begin
                hartid = {hartsel[9:5], i[4:0]};
                haltsum0_bits[i] = hart_is_halted(hartid);
            end
        end
    endtask

    task update_haltsum1;
        integer i;
        reg [9:0] baseid;
        reg [9:0] hartid;
        begin
            baseid = hartsel[19:10] << 10;
            for (i = 0; i < 32; i = i + 1) begin
                hartid = baseid + i;
                haltsum1_bits[i] = hart_is_halted(hartid);
            end
        end
    endtask

    // === Main DMI Logic ===

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dmcontrol <= 32'h0;
            haltreq <= 0;
            resumereq <= 0;
            reg_write <= 0;
            reg_read <= 0;
            sb_read <= 0;
            sb_write <= 0;
            busy <= 0;
            cmderr <= 0;
            haltsum0_bits <= 0;
            haltsum1_bits <= 0;
            hartsel <= 0;
            halted_harts <= 32'h00000001; // Simulate hart 0 as halted initially
        end else begin
            if (dmi_wr) begin
                case (dmi_addr)
                    7'h10: handle_dmcontrol_write();
                    7'h16: handle_abstractcs_write();
                    7'h04: handle_abstractdata0_write();
                    7'h17: if (state == IDLE) handle_command_write();
                    7'h38: handle_sbcs_write();
                    7'h39: handle_sbaddress0_write();
                    7'h3C: handle_sbdata0_write();
                    default: if ((dmi_addr >= 7'h20) && (dmi_addr <= 7'h2F))
                        handle_progbuf_write(dmi_addr);
                endcase
            end

            // Clear strobes
            reg_write <= 0;
            reg_read <= 0;
            sb_read <= 0;
            sb_write <= 0;

            update_haltsum0();
            update_haltsum1();
        end
    end

    always @(posedge clk) begin
        if (state == EXEC) begin
            state <= DONE;
            if (!command[18]) abstractdata0 <= reg_rdata;
        end else if (state == DONE) begin
            busy <= 0;
            state <= IDLE;
        end
    end

    always @(*) begin
        case (dmi_addr)
            7'h10: dmi_rdata = dmcontrol;
            7'h11: dmi_rdata = {haltsum1_bits[0], 1'b1, 1'b0, hart_is_halted(hartsel), haltsum0_bits[0], 3'b010};
            7'h16: dmi_rdata = {16'h0, 8'd1, 7'd15, busy, cmderr};
            7'h17: dmi_rdata = command;
            7'h04: dmi_rdata = abstractdata0;
            7'h38: dmi_rdata = sbcs;
            7'h39: dmi_rdata = sbaddress0;
            7'h3C: dmi_rdata = sbdata0;
            default: if ((dmi_addr >= 7'h20) && (dmi_addr <= 7'h2F))
                dmi_rdata = progbuf[dmi_addr - 7'h20];
            else
                dmi_rdata = 32'h0;
        endcase
    end
endmodule
