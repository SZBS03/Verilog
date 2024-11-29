module register_tb;
    reg clk;
    reg enable;
    reg reset;
    reg [31:0] write_data;
    reg [4:0] rd_data;
    reg [4:0] rs1_data;
    reg [4:0] rs2_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register u_register (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .write_data(write_data),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        write_data = 32'b0;
        rd_data = 5'b0;
        rs1_data = 5'b0;
        rs2_data = 5'b0;
        rs2_data = 5'd1;

        #10 reset = 0;
        #10 enable = 1;
        rd_data = 5'd1;
        write_data = 32'hDEAD;

        #10 rd_data = 5'd1;

        #10 enable = 1;
        reset = 1;
        #10 reset = 0;

        #10 rs1_data = 5'd1;
        #50;
        $finish;
    end

initial begin
    $dumpfile("./temp/reg.vcd");
    $dumpvars(0,register_tb);    
end

endmodule