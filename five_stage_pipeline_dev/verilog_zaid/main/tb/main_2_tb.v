module main_tb();
    reg clk;

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Instantiate the Unit Under Test (UUT)
    main u_main (
        .clk(clk)
    );

    // Test cases
    initial begin
        clk = 1;
        #150;
        $finish;
    end

    initial begin
        $dumpfile("temp\\main_2.vcd");
        $dumpvars(0,main_tb); 
    end
endmodule
