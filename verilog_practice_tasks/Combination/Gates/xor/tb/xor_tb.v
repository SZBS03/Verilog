module xor_tb();
reg a_tb;
reg b_tb;
wire c_tb;

xor u_xor(
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
    $dumpfile("xor.vcd");
    $dumpvars(0,xor_tb);
end

endmodule