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
    rst = 0;
    RW = 0;
    en = 1;
    #5 rst = 1;
    #10 rst = 0;

    dataIN = 32'h00400093;  #10;// ADDI x1, x0, 4
    dataIN = 32'h00500113;  #10;// ADDI x2, x0, 5
    dataIN = 32'h40110233;  #10 RW = 1; // SUB x4, x2, x1

    #100 $finish;
end


initial begin
    $dumpfile("temp/main.vcd");
    $dumpvars(0,MAIN_tb); 
end


endmodule