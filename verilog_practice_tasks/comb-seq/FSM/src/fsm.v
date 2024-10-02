module FSM(
    input wire  clk,
    input wire  rst,
    input wire busy,
    input wire tx,
    input wire [4:0] data
);

wire a;
wire b;
wire [4:0] c;


transmission_state u_transmission_state(
    .clk(clk),
    .rst(rst),
    .tx(tx),
    .ready_i(a),
    .data(data),
    .valid_o(b),
    .data_o(c)
);

receiver_state u_receiver_state(
    .valid_i(b),
    .data_i(c),
    .busy(busy),
    .ready_o(a)

);

endmodule
