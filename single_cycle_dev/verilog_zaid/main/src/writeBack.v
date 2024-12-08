module WriteBack (
    input wire clk,
    input wire [31:0] load_write,
    input wire [31:0] PC_in,
    input wire [31:0] aluOut,
    input wire memToReg,
    input wire jalEN,
    input wire jalrEN,
    output reg [31:0] write_data,
    output reg [31:0] PC_out,
    output reg jump
);
    always @(posedge clk) begin
        jump = 0;
        if ( jalEN || jalrEN ) begin
            write_data <= PC_in + 4;
            PC_out <= aluOut; 
            jump <= 1;
        end
    end

    always @(*) begin
        if (memToReg) begin
            write_data = load_write;
        end
        else begin
            write_data = aluOut;
        end
    end
endmodule