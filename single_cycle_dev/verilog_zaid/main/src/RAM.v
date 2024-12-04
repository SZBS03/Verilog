module RAM (
    input wire clk,
    input wire [31:0] MemWrite,
    input wire [31:0] rs1,
    input wire [31:0] Immediate,
    input wire memToReg,
    input wire memWrite,   
    output reg [31:0] MemRead
);
    reg [31:0] RAM [0:31]; 

    wire [31:0] loc;
    assign loc = rs1 + Immediate;
    wire [4:0] address;
    assign address = loc [4:0];
    integer i;

    always @(posedge clk) begin
        if(~memToReg && ~memWrite) begin
        for(i=0; i<32; i++) begin
            RAM[i] <= 32'd0;
        end
        end
        if (memToReg) begin              //readWrite true -> Read and false -> Write
            MemRead <= RAM[loc];
        end 
        else if (memWrite) begin
            RAM[loc] <= MemWrite;
        end

    end
endmodule
