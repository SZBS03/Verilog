module RAM (
    input wire clk,
    input wire [31:0] StoreData,
    input wire [31:0] LoadData,
    input wire [31:0] rs1,
    input wire [31:0] Immediate,
    input wire readWrite,   
    output reg [31:0] dataOUT
);
    reg [31:0] RAM [0:31]; // 32 words of memory
    wire [31:0] loc;
    assign loc = rs1 + Immediate;
    wire [4:0] address;
    assign address = loc [4:0];

    always @(posedge clk) begin
        if (readWrite) begin
            dataOUT <= RAM[address];
        end 
        else if (~readWrite) begin
            RAM[address] <= dataIN; // Write
        end

    end
endmodule
