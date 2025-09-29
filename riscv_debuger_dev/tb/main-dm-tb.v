module dmi_main_tb();
    reg clk;
    parameter LEN = 128 , WID = 32, NOC = 33;
    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Instantiate the Unit Under Test (UUT)
    dmi_main #(.LEN(LEN), .WID(WID), .NUMBEROFCORES(NOC)) u_dmi_main (
        .clk(clk),
        .reset(reset)
    );

    // Test cases
    initial begin
        clk = 0;
        #1000000;
        $finish;
    end

    initial begin
        $dumpfile("main_dm.vcd");
        $dumpvars(0,dmi_main_tb); 
    end
endmodule
