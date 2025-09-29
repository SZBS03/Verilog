// This module acts as a bridge between DM and core’s RF
module regfile_interface #(parameter WIDTH = 32)
(
    input wire clk,
    input wire rst,

    input wire reg_read,
    input wire reg_write,
    input wire [4:0]  reg_addr,
    input wire [31:0] reg_wdata,
    output reg [31:0] reg_rdata,

    // Core’s real RF interface
    output reg rf_we,
    output reg [$clog2(WIDTH)-1:0]  rf_addr,
    output reg [WIDTH-1:0] rf_wdata,
    input wire [WIDTH-1:0] rf_rdata
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rf_we <= 0;
            reg_rdata <= 0;
        end else begin
            rf_we <= 0;
            if (reg_write) begin
                rf_we <= 1;
                rf_addr <= reg_addr[$clog2(WIDTH)-1:0];
                rf_wdata <= reg_wdata;
            end else if (reg_read) begin
                rf_addr <= reg_addr[$clog2(WIDTH)-1:0];
                reg_rdata <= rf_rdata[31:0];
            end
        end
    end
endmodule
