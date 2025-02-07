module IFIDRegister (
input wire clk,
input wire IF_flush,
input wire IFIDWrite,
input wire [31:0] PC,
input wire [31:0] instruction,
output reg [31:0] nextinst,
output reg [31:0] nextPC
);
    reg [31:0] IFID [0:1]; //two alocations for PC and Instruction.
    integer i;

    always @(posedge clk) begin
        if (IF_flush) begin
            for (i = 0; i < 2; i = i + 1) 
                IFID[i] <= 32'b0; 
        end else if (IFIDWrite) begin 
            //read
                IFID [0] <= PC;
                IFID [1] <= instruction;
            //write
                nextPC <= IFID [0];
                nextinst <= IFID [1];
        end
    end

endmodule
