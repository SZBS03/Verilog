module register_tb();
    reg clk;
    reg enable;
    reg reset;
    reg [31:0] write_data;
    reg [4:0] rd_data;
    reg [4:0] rs1_data;
    reg [4:0] rs2_data;
    wire [32:0] read_data1;
    wire [32:0] read_data2;

register u_register(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .write_data(write_data),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    enable = 0;
    reset = 0;
    #5;
    reset = 1;
    enable = 0;
    #5;
    enable = 1;
    reset = 0;
    write_data = 32'd435;
    rd_data = 5'd8;
    rs1_data = 5'd8;
    rs2_data = 5'd9;
    #70;
    reset = 1;
    enable = 0;
    #100;
    $finish;
end

initial begin
    $dumpfile("temp/register.vcd");
    $dumpvars(0,register_tb);
end

endmodule