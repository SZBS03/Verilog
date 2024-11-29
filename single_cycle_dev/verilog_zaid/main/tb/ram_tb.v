module RAM_tb ();
    reg clk;
    reg readWrite;
    reg [31:0] dataIN;
    reg [4:0] address;
    wire [31:0] dataOUT; 

RAM u_RAM(
    .clk(clk),
    .readWrite(readWrite),
    .dataIN(dataIN),
    .address(address),
    .dataOUT(dataOUT)
);

always  begin
    #5 clk = ~clk;
end

initial begin
    clk = 1;
    dataIN = 32'd90;
    address = 5'd21;
    readWrite = 0;
    #10;
    dataIN = 32'd24;
    address = 5'd29;
    readWrite = 1;
    #10;
    dataIN = 32'd34;
    address = 5'd31;
    readWrite = 0;
    #10;
    dataIN = 32'd46;
    address = 5'd30;
    readWrite = 1;
    #10;
    dataIN = 32'd12;
    address = 5'd4;
    readWrite = 0;
    #10;
    readWrite = 1;
    #100;
    $finish;
end

initial begin
    $dumpfile("./temp/ram.vcd");
    $dumpvars(0,RAM_tb);
end
endmodule