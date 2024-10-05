module transmission_state(
    input wire clk,
    input wire rst,
    input wire ready_i,
    input wire tx,
    input wire [4:0] data,
    output reg valid_o,
    output reg [4:0] data_o
);
localparam idle = 2'b00;
localparam TX = 2'b01;
localparam valid = 2'b10;
reg [1:0] state;
reg [1:0] next_state;


always @(posedge clk or negedge rst) begin
    if(~rst) begin
        state <= idle;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        idle: begin
            valid_o = 0;
            next_state = TX;
        end
        TX: begin
            valid_o = 0;
            next_state = (tx) ? valid : TX; 
        end
        valid: begin
            valid_o = 1;
            next_state = (ready_i) ? TX : valid;
            data_o = (ready_i) ? data : 5'bx;
        end
    endcase
end
endmodule
