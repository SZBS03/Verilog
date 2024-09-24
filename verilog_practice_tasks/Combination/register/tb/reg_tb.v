module register_tb();
    reg enable;
    reg [4:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

register u_register(
    .enable(enable),
    .address(address),
    .data_in(data_in),
    .data_out(data_out)
);

initial begin
    enable = 1;
    #10;
    address = 3;
    data_in = 32'd9;
    #10;
    enable = 0;
    #10;
    enable = 1;
    data_in = 32'd8;
    address = 9;
    #10;
    enable = 0;
    #100;
    $finish;
end

initial begin
    $dumpfile("temp/reg.vcd");
    $dumpvars(0,register_tb);
end

endmodule