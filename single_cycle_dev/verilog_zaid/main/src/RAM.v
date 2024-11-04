module RAM (
    input wire clk,
    input wire [31:0] dataIN,
    input wire [4:0] address,
    input wire load,
    input wire store,
    output reg [31:0] dataOUT 
);
reg [31:0] RAM [0:31];

    always @(posedge clk) begin
        if(clk) begin
            if(RW) begin
                dataOUT <= RAM[address];
            end
            else begin
                RAM[address] <= dataIN;
            end
        end     
    end
endmodule