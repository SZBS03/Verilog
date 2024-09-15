module halfadder(
    input wire a,
    input wire b,
    
    output reg carry,
    output reg sum
);

assign sum =  a ^ b;
assign carry = a & b;

endmodule