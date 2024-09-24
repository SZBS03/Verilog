module register(
    input wire clk,
    input wire enable,
    input [4:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out
);
reg [31:0] memory [0:31];

always @(posedge clk) begin
    if (enable) begin
        memory[address] <= data_in;
           end
    else begin
        data_out <= memory[address];
    end
end
endmodule