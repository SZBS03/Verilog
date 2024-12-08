module MAIN_tb();
    reg clk;
    reg [31:0]dataIN;
    reg rst;
    reg en;
    reg RW;


always begin
    #5 clk = ~clk;
end

MAIN u_MAIN(
    .clk(clk),
    .dataIN(dataIN),
    .rst(rst),
    .en(en),
    .RW(RW)
);


initial begin
    clk = 1;
    rst = 1;
    #5 rst = 0;
    en = 1;
    #10 rst = 1;
    #5 rst = 0;
    #450 en = 0;
    #500 $finish;
end


initial begin
    $dumpfile("temp/main.vcd");
    $dumpvars(0,MAIN_tb); 
end


endmodule