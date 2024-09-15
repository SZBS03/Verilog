module counter_tb();
    reg rst_tb;
    reg clk_tb;
    wire [3:0]q_tb;

    counter u_counter(
        .rst(rst_tb),
        .clk(clk_tb),
        .q(q_tb)
    );

    initial begin
        rst_tb = 0;
        clk_tb = 0;
        #10;
        rst_tb = 1;
        #190;
        $finish;
    end

    initial begin
        $dumpfile("temp/counter.vcd");
        $dumpvars(0,counter_tb);

    end
    always begin
        #5 clk_tb = !clk_tb;
    end

    endmodule