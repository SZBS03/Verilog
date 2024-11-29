module Counter_tb();
    reg rst;
    reg clk;
    wire [31:0]o;

always begin
    #5 clk = ~clk;

end 

Counter u_Counter(
    .rst(rst),
    .clk(clk),
    .out(o)
);

initial begin
        clk = 0;   
        rst = 1;   
        #10 rst = 0; 
        #100;        
        $finish;    
end

initial begin
    $dumpfile("temp/counter.vcd");
    $dumpvars(0,Counter_tb);
end

endmodule