module system_bus_memory #(parameter LENGTH = 128)
(
    input wire clk,
    input wire [31:0] sb_addr,
    input wire [31:0] sb_wdata,
    output reg [31:0] sb_rdata,
    input wire sb_read,
    input wire sb_write,
    output reg sb_ready,
    output reg [LENGTH-1:0] sb_wvalid,
    output reg [7:0] sb_mem [0:LENGTH-1]
);

    integer i;

    initial begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            sb_mem[i] = 8'h00;
        end
    end

    always @(posedge clk) begin
        sb_ready = 0;

        if (sb_read) begin
            sb_rdata <= {
                sb_mem[sb_addr+3],
                sb_mem[sb_addr+2],
                sb_mem[sb_addr+1],
                sb_mem[sb_addr+0]
            };
            sb_ready <= 1;
        end
        else if (sb_write) begin
            sb_mem[sb_addr + 0] <= sb_wdata[7:0];
            sb_mem[sb_addr + 1] <= sb_wdata[15:8];
            sb_mem[sb_addr + 2] <= sb_wdata[23:16];
            sb_mem[sb_addr + 3] <= sb_wdata[31:24];

            sb_wvalid[sb_addr + 0] <= 1;
            sb_wvalid[sb_addr + 1] <= 1;
            sb_wvalid[sb_addr + 2] <= 1;
            sb_wvalid[sb_addr + 3] <= 1;

            sb_ready <= 1;
        end
    end
endmodule
