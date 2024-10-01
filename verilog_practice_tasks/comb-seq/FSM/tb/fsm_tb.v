module FSM_tb();
    reg clk;
    reg reset;
    reg busy;
    reg tx;
    reg [4:0]data;
    wire [4:0]data_s;

FSM u_FSM(
    .clk(clk),
    .rst(reset),
    .busy(busy),
    .tx(tx),
    .data(data),
    .data_s(data_s)
);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 1;
    reset = 1;
    data = 5'b00010;
    #5;
    reset = 0;
    tx = 0;
    #5;
    reset = 1;
    #5;
    tx=1;
    busy=1;
    #10;
    busy=0;
    #100;
    $finish;
end

initial begin
    $dumpfile("temp/fsm.vcd");
    $dumpvars(0,FSM_tb);
end

endmodule