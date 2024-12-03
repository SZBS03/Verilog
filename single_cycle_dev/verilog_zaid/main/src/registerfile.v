module register (
    input wire clk,
    input wire reset,
    input wire regWrite, 
    input [31:0] write_data,
    input [4:0] rd_data,
    input [4:0] rs1_data,
    input [4:0] rs2_data,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);
    reg [31:0] registerf [0:31];
    integer i;

    // Synchronous
    always @(posedge clk) begin
        if (reset || ~regWrite) begin
            for (i = 0; i < 32; i = i + 1) 
                registerf[i] <= 32'b0; 
        end else if (regWrite && rd_data != 0) begin
            registerf[rd_data] <= write_data; 
        end
    end

    // ASynchronous
    always @(*) begin
        read_data1 = (rs1_data == 0) ? 32'b0 : registerf[rs1_data];
        read_data2 = (rs2_data == 0) ? 32'b0 : registerf[rs2_data];
    end

endmodule
