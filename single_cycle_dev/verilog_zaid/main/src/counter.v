module Counter(
    input wire rst,
    input wire clk,
    output reg [31:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            out <= 32'b0; 
        else 
            out <= out + 32'd4; 
    end
endmodule
