module DRAM_tb();
    reg clk;
    reg [1:0]address;
    reg [71:0]dataIN;
    wire [71:0]dataOUT;
    reg Write_ReadCOMP;

DRAM u_DRAM(
    .clk(clk),
    .address(address),
    .dataIN(dataIN),
    .dataOUT(dataOUT),
    .Write_ReadCOMP(Write_ReadCOMP)
);

always begin
    clk = ~clk;
    #5;
end

initial begin
    clk = 0;
    address = 2'b10;
    dataIN = 72'd12;
    #5;
    Write_ReadCOMP=0;
    #5;
    Write_ReadCOMP=1;
    #10;
    Write_ReadCOMP=0;
    #100;
    $finish;
end

initial begin
    $dumpfile("temp/dram.vcd");
    $dumpvars(0,DRAM_tb);
end

endmodule