module WriteBack(
    input wire [31:0]load_data,
    input wire loadEN,
    input wire [31:0]aluIN,
    output reg [31:0]rd_data
);
    assign rd_data = (loadEN) ? load_data : aluIN;
 
 endmodule