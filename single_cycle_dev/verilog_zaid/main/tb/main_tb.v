module MAIN_tb();
    reg clk;
    reg [31:0]dataIN;
    reg rst;
    reg en;
    reg RW;

MAIN u_MAIN(
    .clk(clk),
    .dataIN(dataIN),
    .rst(rst),
    .en(en),
    .RW(RW)
);

initial begin
    clk = 0;
    rst = 0;
    RW = 0;
    en = 1;
    dataIN = 32'd5243027;
    #5;
    dataIN = 32'd7340435;
    #5;
    dataIN = 32'd2130227;
    #5;
    RW = 1;
    #30;
    RW = 0;
    #40;
    rst = 1;
    #100;
end

initial begin
    $dumpfile("temp/main.vcd");
    $dumpvars(0,MAIN_tb); 
end

always begin
    #5 clk = ~clk;
end

endmodule