module transmission_state(
    input wire clk,
    input wire rst,
    input wire ready_i,
    input wire tx,
    input wire [4:0] data,
    output reg valid_o,
    output reg [4:0] data_o,
    input wire [1:0] state,        
    output wire [1:0] next_state   
);
localparam idle = 2'b00;
localparam TX = 2'b01;
localparam valid = 2'b10;
reg [1:0] next_state_reg;  

always @(*) begin
    case (state)
        idle: begin
            valid_o = 0;
            next_state_reg = TX;
        end
        TX: begin
            valid_o = 0;
            next_state_reg = (tx) ? valid : TX; 
        end
        valid: begin
            valid_o = 1;
            data_o = data;
            next_state_reg = (ready_i) ? TX : valid;
        end
    endcase
end

assign next_state = next_state_reg;  

endmodule
