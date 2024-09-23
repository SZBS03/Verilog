module register_tb();
    reg clk;
    reg enable;
    reg [4:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

register u_register(
    .clk(clk),
    .enable(enable),
    .address(address),
    .data_in(data_in),
    .data_out(data_out)
);

always begin
    #5 clk = !clk;
end

initial begin
    clk = 0;
    enable = 1;
    #10;
    address = 3;
    data_in = 32'd9;
    #10;
    enable = 0;
    address = 3;
    #100;
    $finish;
end

initial begin
    $dumpfile("temp/register.vcd");
    $dumpvars(0,register_tb);
end

endmodule