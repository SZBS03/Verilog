module blocking_tb();
reg [3:0]a,b,c;

initial begin
    a = #3 1;
    b = #5 2;
    c = #10 3;
end

initial begin
    $dumpfile("blocking.vcd");
    $dumpvars(0,blocking_tb);
end
    
endmodule