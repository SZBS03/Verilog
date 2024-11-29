module Counter(
    input wire rst,
    input wire clk,
    output reg [31:0] out
);
    wire [31:0] o;
    assign o = 32'd4;

    always @(posedge clk or posedge rst) begin
        if (rst) 
            out <= 32'b0; 
        else 
            out <= out + o; 
    end
endmodule
