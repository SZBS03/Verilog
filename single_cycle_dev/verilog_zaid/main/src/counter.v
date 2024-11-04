module Counter(
    input wire rst,
    input wire clk,
    output reg [31:0]o
);

always @(posedge clk) begin
    if(clk) begin
        o <= o + 32'd4;
    end
end

endmodule