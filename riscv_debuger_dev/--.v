
// 32-bit RISC-V Debug Module Interface (v0.13.2)
// For 0-33 core systems. Only mandatory registers implemented.

module DMI (
  input  wire        clk,
  input  wire        reset,

  // DMI Interface
  input  wire        dmi_wr,
  input  wire        dmi_rd,
  input  wire [6:0]  dmi_addr,
  input  wire [31:0] dmi_wdata,
  output reg  [31:0] dmi_rdata,

  // Core Debug Interface
  output reg         haltreq,
  output reg         resumereq,
  input  wire        halted,
  output reg  [4:0]  reg_addr,
  output reg  [31:0] reg_wdata,
  output reg         reg_write,
  output reg         reg_read,
  input  wire [31:0] reg_rdata,

  // System Bus Interface
  output reg  [31:0] sb_addr,
  output reg  [31:0] sb_wdata,
  input  wire [31:0] sb_rdata,
  output reg         sb_read,
  output reg         sb_write,
  input  wire        sb_ready
);

  // DMI Registers
  reg [31:0] dmcontrol, abstractcs, command, abstractdata0;
  reg [31:0] sbcs, sbaddress0, sbdata0;
  reg [31:0] progbuf[0:15];
  reg [31:0] hawindowsel, hawindow;

  // Internal State
  reg        busy;
  reg  [2:0] cmderr;
  reg  [9:0] hartsel;
  reg  [32:0] halted_harts;
  reg  [1:0] state;
  localparam IDLE = 2'b00, EXEC = 2'b01, DONE = 2'b10;

  // Tasks
  task write_dmcontrol;
  begin
    dmcontrol <= dmi_wdata;
    haltreq   <= dmi_wdata[31];
    resumereq <= dmi_wdata[30];
    hartsel   <= dmi_wdata[25:16];
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
    if (~halted_harts[hartsel]) begin cmderr<=3'b001; busy<=0; end
    else if (dmi_wdata[19]) begin
      if (dmi_wdata[18]) begin
        reg_wdata <= abstractdata0;
        reg_write <= 1;
      end else begin
        reg_read <= 1;
      end
      state <= EXEC;
    end else state<=DONE;
  end endtask

  task write_sbcs;   begin sbcs <= dmi_wdata; end endtask
  task write_sbaddress0;
  begin
    sbaddress0 <= dmi_wdata;
    if (sbcs[21]) begin sb_addr <= dmi_wdata; sb_read <= 1; end
  end endtask

  task write_sbdata0;
  begin
    sbdata0 <= dmi_wdata;
    sb_wdata <= dmi_wdata;
    sb_addr <= sbaddress0;
    sb_write <= 1;
  end endtask

  task write_progbuf;
    input [6:0] addr;
  begin
    progbuf[addr - 7'h20] <= dmi_wdata;
  end endtask

  task write_hawindowsel;
  begin hawindowsel <= dmi_wdata; end endtask

  task write_hawindow;
  begin hawindow <= dmi_wdata; end endtask

  // Main Write
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      dmcontrol <= 0; haltreq <= 0; resumereq <= 0;
      reg_write <= 0; reg_read <= 0;
      sb_read <= 0; sb_write <= 0;
      busy <= 0; cmderr <= 0;
      hartsel <= 0; state <= IDLE;
      halted_harts <= 33'h1; // hart0 only
    end else begin
      if (dmi_wr) begin
        case (dmi_addr)
          7'h10: write_dmcontrol();
          7'h16: write_abstractcs();
          7'h04: write_abstractdata0();
          7'h17: if (state == IDLE) write_command();
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
    if (state == EXEC) begin
      state <= DONE;
      if (~command[18]) abstractdata0 <= reg_rdata;
    end else if (state == DONE) begin
      busy <= 0; state <= IDLE;
    end
  end

  // dmstatus
  wire [31:0] dmstatus_value = {
    1'b0, 1'b0, 1'b0, // impebreak, allhavereset, anyhavereset
    1'b1, 1'b1,       // allresumeack, anyresumeack
    1'b0, 1'b0,       // allnonexistent, anynonexistent
    1'b0, 1'b0,       // allunavail, anyunavail
    ~|halted_harts,   // allrunning (NORed if any all are low from array of reg)
    |~halted_harts,   // anyrunning (ORed array of reg)
    &halted_harts,    // allhalted
    |halted_harts,    // anyhalted
    1'b1, 1'b0,       // authenticated, authbusy
    1'b1, 1'b0,       // hasresethaltreq, confstrptrvalid
    3'b010            // version (v0.13)
  };

  // Read Logic
  always @(*) begin
    case (dmi_addr)
      7'h04: dmi_rdata = abstractdata0;
      7'h10: dmi_rdata = dmcontrol;
      7'h11: dmi_rdata = dmstatus_value;
      7'h14: dmi_rdata = hawindowsel;
      7'h15: dmi_rdata = {31'b0, halted_harts[0]};  //only implemented for single core
      7'h16: dmi_rdata = {16'd0, 8'd1, 7'd15, busy, cmderr};
      7'h17: dmi_rdata = command;
      7'h38: dmi_rdata = sbcs;
      7'h39: dmi_rdata = sbaddress0;
      7'h3C: dmi_rdata = sbdata0;
      default:
        if ((dmi_addr >= 7'h20) && (dmi_addr <= 7'h2F))
          dmi_rdata = progbuf[dmi_addr - 7'h20];
        else
          dmi_rdata = 32'd0;
    endcase
  end
endmodule
