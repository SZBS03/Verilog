module RAM (
    input wire clk,
    input wire [31:0] dataIN,
    input wire [4:0] address,
    input wire readWrite,
    output reg [31:0] dataOUT 
);
reg [31:0] RAM [0:31];

    always @(posedge clk) begin
            if(~readWrite) begin
                RAM[address] <= dataIN;
            end
            else begin
                dataOUT <= RAM[address];
            end
        end     
endmodule