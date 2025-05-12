module dmstat (
    input wire [31:0] dmstat_reg_i,
    output reg [31:0] dmstat_reg_o
);
    wire impebreak = dmstat_reg_i[22];
    wire allhavereset = dmstat_reg_i[19];
    wire anyhavereset = dmstat_reg_i[18];
    wire allresumeack = dmstat_reg_i[17];
    wire anyresumeack = dmstat_reg_i[16];
    wire allnonexistent = dmstat_reg_i[15];
    wire anynonexistent = dmstat_reg_i[14];
    wire allunvail = dmstat_reg_i[13];
    wire anyunvail = dmstat_reg_i[12];
    wire allrunning = dmstat_reg_i[11];
    wire anyrunning = dmstat_reg_i[10];
    wire allhalted = dmstat_reg_i[9];
    wire anyhalted = dmstat_reg_i[8];
    wire authenticated = dmstat_reg_i[7];
    wire autbusy = dmstat_reg_i[6];
    wire hasresethaltreq = dmstat_reg_i[5];
    wire confstrptrvailid = dmstat_reg_i[4];
    wire [3:0] version = dmstat_reg_i[3:0];

always @(*) begin


end

endmodule
