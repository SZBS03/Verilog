module receiver_state(
    input wire valid_i,
    input wire [4:0] data_i,
    input wire busy,
    output reg ready_o,
    output reg [4:0] data_s,
    input wire [1:0] state,        
    output wire [1:0] next_state   
);
localparam valid = 2'b10;
reg [1:0] next_state_reg;  

always @(*) begin
    case (state)
        valid: begin
            if (valid_i == 1 && data_i != 5'bx) begin 
                ready_o = (busy) ? 0 : 1;
                data_s = data_i;
            end else begin
                next_state_reg = valid;
            end
        end
    endcase
end

assign next_state = next_state_reg;  

endmodule
