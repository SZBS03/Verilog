module counter(
    input wire rst,
    input wire clk,
    
    output reg [3:0]q
);

always @(posedge clk or negedge rst) begin
    if(~rst) begin
        q<=4'b0000;
    end
    else begin
        q<= 2 + q;
    end

end

endmodule