module register(
    input wire clk,
    input wire enable,
    input wire reset,
    input [31:0] write_data,
    input [4:0] rd_data,
    input [4:0] rs1_data,
    input [4:0] rs2_data,
    output wire [32:0] read_data1,
    output wire [32:0] read_data2
);

//sequential section
reg [31:0] registerf [0:31];
integer i;
always @(posedge clk) begin
    if(reset) begin
        for(i=0; i<32; i++)
        registerf[i]<=0;
    end
    else begin
        if(enable) registerf[rd_data] <= write_data;
    end
end

//combination section
assign read_data1 = (rs1_data == 0) ? 32'b0 : registerf[rs1_data];
assign read_data2 = (rs2_data == 0) ? 32'b0 : registerf[rs2_data];

endmodule