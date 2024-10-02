module receiver_state(
    input wire valid_i,
    input wire [4:0] data_i,
    input wire busy,
    output reg ready_o

);
reg [4:0] data_s; 
always @(*) begin
    if (valid_i && busy) begin 
        ready_o =  0;
        end
    else if(valid_i && ~busy) begin
        ready_o = 1;
    end
     
    else begin
        ready_o = 0;
    end
end

endmodule
