module RAM (
    input wire clk,
    input wire [31:0] dataIN,
    input wire [4:0] address, //1 
    input wire readWrite,   //0
    output reg [31:0] dataOUT
);
    reg [31:0] RAM [0:31]; // 32 words of memory

    always @(posedge clk) begin
        if (readWrite) begin
            dataOUT <= RAM[address - 3]; // Read   (here address - 3 is me pushing back the address value by 3, where 3 is the number of instructions, this is temporary to test of all instruction)
        end else begin
            RAM[address] <= dataIN; // Write
        end
    end
endmodule
