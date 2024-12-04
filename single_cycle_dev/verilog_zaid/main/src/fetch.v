module fetch(
    input wire clk,
    input wire rst,
    input wire en,
    input wire jump,
    input wire [31:0] JPC,
    output reg [31:0] counterOUT,  
    output reg [4:0] mem_address,  
    output reg [31:0] instruction       
);

    reg [31:0] FPC;  
    reg [31:0] INST_MEM [0:31];  
    
    initial begin
        $readmemh("file.mem", INST_MEM);
    end

    always @(*) begin
    if (~jump) begin
        FPC = counterOUT;
    end else begin
        FPC = JPC;
    end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            FPC <= 32'd0; // Reset PC to zero
        end else if (en) begin
            FPC <= FPC + 32'd4; // Increment PC by 4 when enabled
        end
    end

    always @(*) begin
        counterOUT = FPC;
        mem_address = FPC[6:2];  // Word-aligned memory address
        instruction = INST_MEM[mem_address];
    end

endmodule
