module FSM(
    input wire  clk,
    input wire  rst,
    input wire busy,
    input wire tx,
    input wire [4:0] data,
    output wire [4:0] data_s
);
localparam idle = 2'b00;
reg [1:0] state;
wire [1:0] next_state;
wire a;
wire b;
wire [4:0] c;

always @(posedge clk) begin
    if(rst) begin
        state <= idle;
    end
    else begin
        state <= next_state;
    end
end

transmission_state u_transmission_state(
    .clk(clk),
    .rst(rst),
    .tx(tx),
    .ready_i(a),
    .data(data),
    .valid_o(b),
    .data_o(c),
    .state(state),
    .next_state(next_state)
);

receiver_state u_receiver_state(
    .valid_i(b),
    .data_i(c),
    .busy(busy),
    .ready_o(a),
    .data_s(data_s),
    .state(state),
    .next_state(next_state)
);


endmodule
