module concat (
    input wire [1:0]a,
    input wire [1:0]b,
    output wire [2:0]c
);
assign  c = {a[0],b[1:0]};

endmodule