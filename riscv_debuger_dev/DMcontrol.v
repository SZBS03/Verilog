module DMcont (
    input wire [31:0] dmcont_reg_i,
    output reg [31:0] dmcont_reg_o
);
    wire haltreq = dmcont_reg_i[31];
    wire resumereq = dmcont_reg_i[30];
    wire hartreset = dmcont_reg_i[29];
    wire ackhavereset = dmcont_reg_i[28];
    wire hasel = dmcont_reg_i[26];
    wire [8:0] hartsello = dmcont_reg_i[25:16];
    wire [8:0] hartselhi = dmcont_reg_i[15:6];
    wire setresethaltreq = dmcont_reg_i[3];
    wire cirrsethaltreq = dmcont_reg_i[2];
    wire ndmreset = dmcont_reg_i[1];
    wire dmactive = dmcont_reg_i[0];

always @(*) begin
    if(~dmactive) begin
        haltreq = 0;
        resumereq = 0;
        hartreset = 0;
        ackhavereset = 0;
        hasel = 0;
        hartsello = 9'd0;
        hartselhi = 9'd0;
        setresethaltreq = 0;
        cirrsethaltreq = 0;
        ndmreset = 0;
    end


    dmcont_reg_o[31] = haltreq;
    dmcont_reg_o[30] = resumereq;
    dmcont_reg_o[29] = hartreset;
    dmcont_reg_o[28] = ackhavereset;
    dmcont_reg_o[26] = hasel;
    dmcont_reg_o[25:16] = [8:0] hartsello;
    dmcont_reg_o[15:6] = [8:0] hartselhi;
    dmcont_reg_o[3] = setresethaltreq;
    dmcont_reg_o[2] = cirrsethaltreq;
    dmcont_reg_o[1] = ndmreset;
    dmcont_reg_o[0] = dmactive;

end

endmodule
