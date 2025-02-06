module alu_tb();
  reg [31:0]a;
  reg [31:0]b;
  reg [5:0]opcode;
  wire [31:0]c;


alu u_alu(
    .a(a),
    .b(b),
    .opcode(opcode),
    .c(c)
);

initial begin
    a = -32'd221;
    b = -32'd122;
    #5;
    opcode = 6'd7;
    #5;
    a = 32'd123;
    b = 32'd124;
    opcode = 6'd8;
    #5;
    opcode = 6'd5;
    #5;
    a = 32'd1223;
    b = 32'd3;
    opcode = 6'd6;
    #5;
    a = -32'd1226;
    b = -32'd1223;
    opcode = 6'd7;
    #5;
    opcode = 6'd8;
    #5;
    opcode = 6'd9;
    #5;
    a = -32'd1223;
    b = 32'd3;
    opcode = 6'd10;
    #5;
    opcode = 6'd11;
    #5;
    opcode = 6'd12;
    #5;
    opcode = 6'd13;
    #5;
    opcode = 6'd18;
    #5;
    opcode = 6'd19;
    #5;
    opcode = 6'd20;
    #5;
    opcode = 6'd21;
    #5;
    opcode = 6'd22;
    #5;
    opcode = 6'd23;
    #5;
    opcode = 6'd24;
    #5;
    opcode = 6'd25;
    #5;
    opcode = 6'd26;
    #5;
    opcode = 6'd27;
    #100;
end

initial begin
   $dumpfile("temp/alu.vcd");
   $dumpvars(0,alu_tb); 
end

endmodule