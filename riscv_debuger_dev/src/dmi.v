// File: DMI.v
// 32-bit RISC-V Debug Module Interface (v0.13.2)
// For up to NOC-core systems. Now adaptable for arbitrary core counts.

module DMI #(parameter LENGTH = 128 , NOC = 33)
(
  input  wire clk,

  // DMI Interface
  input  wire dmi_wr,
  input  wire dmi_rd,
  input  wire [6:0]  dmi_addr,
  input  wire [31:0] dmi_wdata,
  output reg  [31:0] dmi_rdata,

  // Core Debug Interface (multi-hart support externally handled)
  output reg  haltreq,
  output reg  resumereq,
  input  wire [NOC-1:0] halted_inputs,
  output reg  [4:0]  reg_addr,
  output reg  [31:0] reg_wdata,
  output reg  reg_write,
  output reg  reg_read,
  input  wire [31:0] reg_rdata,

  // System Bus Interface
  output reg  [31:0] sb_addr,
  output reg  [31:0] sb_wdata,
  input  wire [31:0] sb_rdata,
  output reg  sb_read,
  output reg  sb_write,
  input  wire sb_ready
);

  reg reset;

  // DMI Registers
  reg [31:0] dmcontrol, abstractcs, command, abstractdata0;
  reg [31:0] sbcs, sbaddress0, sbdata0;
  reg [31:0] progbuf[0:15];
  reg [31:0] hawindowsel, hawindow;
  reg [31:0] authdata;
  reg [NOC-1:0] halted_harts;

  // Internal State
  reg busy;
  reg  [2:0] cmderr;
  reg  [9:0] hartsello;
  reg  [1:0] state;
  wire authbusy = 1'b0;
  localparam IDLE = 2'b00, EXEC = 2'b01, DONE = 2'b10, WAIT_SB = 2'b11;

  // Decoded dmcontrol fields (derived from written value)
  wire dmactive            = dmcontrol[0];
  wire ndmreset            = dmcontrol[1];
  wire clrresethaltreq     = dmcontrol[2];
  wire setresethaltreq     = dmcontrol[3];
  wire [9:0] hartselhi     = dmcontrol[15:6];
  wire [9:0] hartsello_dec = dmcontrol[25:16];
  wire hasel               = dmcontrol[26];
  wire ackhavereset        = dmcontrol[28];
  wire hartreset           = dmcontrol[29];
  wire resumereq_dec       = dmcontrol[30];
  wire haltreq_dec         = dmcontrol[31];

  // Only allow signals to take effect if dmactive is set
  wire haltreq_masked   = dmactive ? haltreq_dec : 1'b0;
  wire resumereq_masked = dmactive ? resumereq_dec : 1'b0;

  // Tasks
  task write_dmcontrol;
  begin
    dmcontrol <= dmi_wdata;
    haltreq   <= haltreq_masked;
    resumereq <= resumereq_masked;
    hartsello   <= dmi_wdata[25:16];
    if (~dmactive) begin
      reset = 1;
      state <= IDLE;
    end
  end endtask

  task write_abstractcs;
  begin
    if (dmi_wdata[10]) cmderr <= 0;
  end endtask

  task write_abstractdata0;
  begin abstractdata0 <= dmi_wdata; end endtask

  task write_command;
  begin
    command <= dmi_wdata;
    busy    <= 1;
    cmderr  <= 0;
    reg_addr <= dmi_wdata[15:0];

    if (~halted_harts[hartsello]) begin
      cmderr <= 3'b001;
      busy   <= 0;
    end else if (dmi_wdata[19]) begin
      if (dmi_wdata[18]) begin
        reg_wdata <= abstractdata0;
        reg_write <= 1;
      end else begin
        reg_read <= 1;
      end
      state <= EXEC;
    end else state <= DONE;
  end endtask

  task write_sbcs; begin sbcs <= dmi_wdata; end endtask

  task write_sbaddress0;
  begin
    sbaddress0 <= dmi_wdata;
    if (sbcs[21]) begin 
      if(dmi_wdata < LENGTH-5) begin
         sb_addr <= dmi_wdata; end 
      sb_read <= 1; state <= WAIT_SB; end
  end endtask

  task write_sbdata0;
  begin
    sbdata0 <= dmi_wdata;
    sb_wdata <= dmi_wdata;
    sb_addr  <= sbaddress0;
    sb_write <= 1;
    state <= WAIT_SB;
  end endtask

  task write_progbuf;
    input [6:0] addr;
  begin
    if(~busy) begin
      progbuf[addr - 7'h20] <= dmi_wdata;
    end
  end endtask

  task write_hawindowsel;
  begin hawindowsel <= dmi_wdata; end endtask

  task write_hawindow;
  begin hawindow <= dmi_wdata; end endtask

  // >>> py logic (harts < 1024) >>> haltsum0 and haltsum1 
  // ... index = 0x00
  // ... next = 0x00
  // ... HAMR = []
  // ... for i in range (0,32):
  // ...     next = i * 32 + 32
  // ...     for j in range (next-32,next):
  // ...         HAMR.append(j)
  // ...     index = i
  // ...     print(f"{index} -> {next}") #for haltsum1 group of harts 
  // ...     print(f"----> {HAMR}") #for haltsum0 individual harts
  // ...     HAMR.clear()

  task read_haltsum;
    input [9:0] base_sel;
    output reg [31:0] result;
    integer i;
  begin
    result = 32'b0;
    for (i = 0; i < 32; i = i + 1)
      if (base_sel + i < NOC)
        result[i] = halted_harts[base_sel + i];
  end endtask

  task write_authdata;
  begin authdata <=  dmi_wdata; end endtask

  // Write Logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      dmcontrol <= 0; haltreq <= 0; resumereq <= 0;
      reg_write <= 0; reg_read <= 0;
      sb_read <= 0; sb_write <= 0;
      busy <= 0; cmderr <= 0;
      hartsello <= 0; state <= IDLE;
      halted_harts <= 0;
    end else begin
      halted_harts <= halted_inputs; // dynamic update
      if (dmi_wr) begin
        case (dmi_addr)
          7'h10: write_dmcontrol();
          7'h16: write_abstractcs();
          7'h04: write_abstractdata0();
          7'h17: if (state == IDLE) write_command();
          7'h30: if (~authbusy) write_authdata();
          7'h38: write_sbcs();
          7'h39: write_sbaddress0();
          7'h3C: write_sbdata0();
          7'h14: write_hawindowsel();
          7'h15: write_hawindow();
          default:
            if ((dmi_addr >= 7'h20) && (dmi_addr <= 7'h2F))
              write_progbuf(dmi_addr);
        endcase
      end
      reg_write <= 0; reg_read <= 0;
      sb_read <= 0; sb_write <= 0;
    end
  end

  // FSM
  always @(posedge clk) begin
    case (state)
      EXEC: begin
        state <= DONE;
        if (~command[18]) abstractdata0 <= reg_rdata;
      end
      DONE: begin
        busy <= 0; state <= IDLE;
      end
      WAIT_SB: begin
        if (sb_ready) begin
          sb_read <= 0; sb_write <= 0;
          state <= DONE;
        end
      end
    endcase
  end

  // dmstatus
  wire [31:0] dmstatus_value;
  assign dmstatus_value = {
    1'b0,                // impebreak
    1'b0,                // allhavereset
    1'b0,                // anyhavereset
    1'b1,                // allresumeack (available)
    1'b1,                // anyresumeack
    1'b0,                // allnonexistent
    1'b0,                // anynonexistent
    1'b0,                // allunavail
    1'b0,                // anyunavail
    ~(|halted_harts),    // allrunning (none halted)
    |(~halted_harts),    // anyrunning
    &halted_harts,       // allhalted
    |halted_harts,       // anyhalted
    1'b1,                // authenticated ( always authenticated)
    1'b0,                // authbusy
    1'b1,                // hasresethaltreq
    1'b0,                // confstrptrvalid
    3'b010               // version (0.13)
  };

  // Read Logic
  always @(*) begin
    if(dmi_rd) begin
      case (dmi_addr)
        7'h04: dmi_rdata = abstractdata0;
        7'h10: dmi_rdata = dmcontrol;
        7'h11: dmi_rdata = dmstatus_value;
        7'h14: dmi_rdata = hawindowsel;
        7'h15: dmi_rdata = hawindow;
        7'h16: dmi_rdata = {16'd0, 8'd1, 7'd15, busy, cmderr};
        7'h17: dmi_rdata = command;
        7'h1d: dmi_rdata = 0; // since only one dm is implemented
        7'h30: dmi_rdata = (~authbusy) ? authdata : 32'd0;
        7'h38: dmi_rdata = sbcs;
        7'h39: dmi_rdata = sbaddress0;
        7'h3C: dmi_rdata = sbdata0;
        7'h13: read_haltsum(hawindowsel[9:5] << 5, dmi_rdata); // haltsum1
        7'h40: read_haltsum(hawindowsel[4:0] << 5, dmi_rdata); // haltsum0
        default:
          if ((dmi_addr >= 7'h20) && (dmi_addr <= 7'h2F))
            dmi_rdata = progbuf[dmi_addr - 7'h20];
          else
            dmi_rdata = 32'd0;
      endcase
    end
  end

endmodule
