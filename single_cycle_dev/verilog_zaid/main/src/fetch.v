module fetch(
    input wire clk,
    input wire rst,
    input wire [31:0] PC,
    output reg [31:0] counter_address

;)
    Counter u_Counter (
        .rst(rst),
        .clk(clk),
        .out(PC)
    );

    assign counter_address = PC[6:2];

    reg [31:0] MEM [0:31];

    initial begin
        $readmemh("file.mem",MEM);
    end 

endmodule