module non_blocking_tb();
reg [3:0]a,b,c;

initial begin
    a <= #3 1;
    b <= #5 2;
    c <= #10 3;
end

initial begin
    $dumpfile("non_blocking.vcd");
    $dumpvars(0,non_blocking_tb);
end
    
endmodule