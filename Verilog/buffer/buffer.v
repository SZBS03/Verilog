module buffer (
    input wire [1:0]a,
    input wire en,
    output wire [1:0]b
);
assign b = !en ? a : 0;

endmodule