module fetch(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [31:0] counterOUT,  
    output reg [4:0] mem_address,  
    output reg [31:0] instruction       
);

    reg [31:0] PC;  
    reg [31:0] INST_MEM [0:31];  

    initial begin
        $readmemh("file.mem", INST_MEM);
    end

    always @(posedge clk or posedge en) begin
        if (~en) begin
            PC = -32'd1;
        end 
        else if (rst) begin
            PC = 32'd0;
        end
        else begin
            PC = PC + 32'd4; 
        end

        counterOUT = PC;
        mem_address = PC[6:2];  
        instruction = INST_MEM[mem_address];
    end

endmodule
