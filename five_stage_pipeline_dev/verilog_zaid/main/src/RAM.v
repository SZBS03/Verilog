module RAM (
    input wire clk,
    input wire [31:0] MemWrite,
    input wire [31:0] rs1,
    input wire [31:0] rd,
    input wire [31:0] Immediate,
    input wire memToReg,
    input wire memWrite,   
    output reg [31:0] MemRead
);
    reg [31:0] RAM [0:31]; 

    reg [31:0] loc;
    reg [4:0] address;

    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
        RAM[i] = 32'd0;
    end
    end

    always @(*) begin
    if (memToReg) begin             
            loc = rs1 + Immediate;
            address = loc [4:0];
    end
    else if (memWrite) begin
            loc = rd + Immediate;
            address = loc [4:0];
    end
    end

    always @(posedge clk) begin
        if (memToReg) begin              //readWrite true -> Read and false -> Write
            MemRead <= RAM[address];

        end 
        else if (memWrite) begin
            RAM[address] <= MemWrite;
        end
    end
    always @(*) begin
    if (memToReg) begin
        MemRead = RAM[address];
    end
end


endmodule
