module DRAM(
    input wire clk,
    input wire reset,
    input [1:0]address,
    input [71:0]dataIN,
    output reg [71:0]dataOUT,
    input wire Write_ReadCOMP
);

reg [71:0] DRAM [3:0];
integer i;

always @(posedge clk) begin
    if(reset) begin
        for (i=0;i<4;i++)
        DRAM[i] = 0;
    end
    else begin 
    if(Write_ReadCOMP) begin 
        DRAM[address] <= dataIN;
    end
    else if(~Write_ReadCOMP) begin 
        dataOUT <= DRAM[address];
    end
    end
end
endmodule