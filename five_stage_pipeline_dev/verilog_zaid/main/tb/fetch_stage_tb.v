module fetch_stage_tb();
    reg PCWrite;
    reg clk;
    wire [31:0] PC;
    wire [31:0] instruction;


always begin
    #5 clk = ~clk;
end

fetch_stage u_fetch_stage(
    .clk(clk),
    .PCWrite(PCWrite),
    .PC(PC),
    .instruction(instruction)
);


initial begin
    clk = 0;
    #5 clk = 1;
    #5 PCWrite = 1;
    #10 PCWrite = 0;
    #5 PCWrite = 0;
    #20 $finish;
end


initial begin
    $dumpfile("temp\\fetch_stage.vcd");
    $dumpvars(0,fetch_stage_tb); 
end


endmodule