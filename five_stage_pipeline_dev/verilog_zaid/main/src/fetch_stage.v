module fetch_stage(
input wire PCWrite,
input wire clk,
output reg [31:0] PC,
output reg [31:0] instruction
);
reg [31:0] INST_MEM [0:31];
reg [31:0] out;
reg [4:0] mem_address;

//program counter
    
    initial begin
        out = 32'b0;
    end

    always @(posedge clk) begin
        if (PCWrite)
            out <= out;
        else begin
            out <= out + 32'd4; 
        end
    end

//instruction memory

    initial begin
        $readmemh("file.mem", INST_MEM);
    end

    always @(*) begin
        PC = out;
        mem_address = out[6:2];  // Word-aligned memory address
        instruction = INST_MEM[mem_address];
    end

endmodule