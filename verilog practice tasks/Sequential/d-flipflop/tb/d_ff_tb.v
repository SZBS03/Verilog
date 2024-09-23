module d_flipflop_tb();
    reg rst_tb;
    reg clk_tb;
    reg [3:0]d_tb;
    wire [3:0]q_tb;

    d_flipflop u_d_flipflop(
        .rst(rst_tb),
        .clk(clk_tb),
        .d(d_tb),
        .q(q_tb)
    );

    initial begin
        rst_tb = 0;
        clk_tb = 0;
        d_tb = 4'b0010;
        #20;
        d_tb = 4'b0011;
        #50;
        rst_tb = 1;
        #190;
        $finish;
    end

    initial begin
        $dumpfile("temp/d_ff.vcd");
        $dumpvars(0,d_flipflop_tb);

    end
    always begin
        #5 clk_tb = !clk_tb;
    end

    endmodule