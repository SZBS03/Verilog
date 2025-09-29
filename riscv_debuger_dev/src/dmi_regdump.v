module dmi_regDump(
    input wire clk,
    output reg dmi_rd,
    output reg dmi_wr,
    output reg [6:0] dmi_addr,
    output reg [31:0] dmi_wdata 
);

reg [31:0] REGINST [0:31];
reg [31:0] REGADDR [0:31];
reg [4:0] address;

initial begin
    integer i;
    for (i = 0; i < 32; i = i + 1) begin
        REGINST[i] = 32'd0;
        REGADDR[i] = 32'd0;
        address = 0;
        dmi_rd = 1;
        dmi_wr = 1;
    end

    $readmemh("riscv_debuger_dev/regInst.txt", REGINST);
    $readmemh("riscv_debuger_dev/regInstaddr.txt", REGADDR);
end

always @(posedge clk) begin
    dmi_addr <= REGADDR[address];
    dmi_wdata <= REGINST[address];
    address <= address + 5'd1;
end

endmodule