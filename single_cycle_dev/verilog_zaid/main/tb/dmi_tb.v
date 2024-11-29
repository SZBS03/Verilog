module DMI_tb();
    reg [31:0]load;
    reg [5:0]aluOP;
    wire [31:0]load_data;

DMI u_DMI(
    .load(load),
    .aluOP(aluOP),
    .load_data(load_data)
);

initial begin
    #10 aluOP = 5'd0;
    load = 32'd42324;
    #10 aluOP = 5'd1;
    //load = -32'd54;
    #10 aluOP = 5'd2;
    load = -32'd31;
    #10 aluOP = 5'd3;
    load = -32'd59;
    #10 aluOP = 5'd4;
    #30;
    $finish;
end

initial begin
    $dumpfile("temp/dmi.vcd");
    $dumpvars(0,DMI_tb);
end

endmodule