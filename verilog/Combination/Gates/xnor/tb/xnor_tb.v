module xnor_tb();
reg a_tb;
reg b_tb;
wire c_tb;

xnor u_xnor(
    .a(a_tb),
    .b(b_tb),
    .c(c_tb)
);

initial begin
    a_tb = 0;
    b_tb = 0;
    #5;
    a_tb = 1;
    b_tb = 0;
    #5;
    a_tb = 0;
    b_tb = 1;
    #5;
    a_tb = 1;
    b_tb = 1;
    #5;
end

initial begin
    $dumpfile("xnor.vcd");
    $dumpvars(0,xnor_tb);
end

endmodule