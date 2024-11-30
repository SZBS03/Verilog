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
            dataOUT <= RAM[address-1]; // Read   ( i did *address-1* in order for RAM to read same instruction in the next cycle instead of dead reading)
        end else begin
            RAM[address] <= dataIN; // Write
        end
    end
endmodule
