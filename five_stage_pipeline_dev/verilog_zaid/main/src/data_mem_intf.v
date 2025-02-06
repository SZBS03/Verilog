module DMI(
    input wire [31:0]load,
    input wire [5:0]aluOP,
    input wire [31:0] rs2,
    output reg [31:0]load_data,
    output reg [31:0]store_data
);
localparam loadByte = 6'd0;
localparam loadHalf = 6'd1;
localparam loadByteUnsigned = 6'd3;
localparam loadHalfUnsigned = 6'd4;
localparam loadWord = 6'd2;
localparam storeWord = 6'd17;
localparam storeHalf = 6'd16;
localparam storeByte = 6'd15;

wire [7:0]LB;
wire [15:0]LH;
wire [7:0]LBU;
wire [15:0]LHU;
wire [31:0]LW;

wire [31:0] SW;
wire [15:0] SH;
wire [7:0] SB;

assign LB = load[7:0];
assign LH = load[15:0];
assign LBU = load[7:0];
assign LHU = load[15:0];
assign LW = load[31:0];

assign SW = rs2;
assign SH = rs2[15:0];
assign SB = rs2[7:0];

always @(*) begin
    case(aluOP)
    loadByte: begin
        load_data = $signed({{25{LB[7]}},LB}); // load bite
    end
    loadHalf: begin
        load_data = $signed({{17{LH[15]}},LH}); // load half bite
    end
    loadByteUnsigned: begin
        load_data = $unsigned({24'b0,LBU}); //load bite unsigned
    end
    loadHalfUnsigned: begin
        load_data = $unsigned({16'b0, LHU}); //load halfword unsigned 
    end
    loadWord: begin
        load_data = LW; //load word remains same 
    end
    storeWord: begin
        store_data = SW;     // store word 
    end
    storeHalf: begin
        store_data = $unsigned({16'b0, SH});    // store half word 
    end
    storeByte: begin
        store_data = $unsigned({24'b0, SB});    // store byte
    end
    default: begin
    load_data = 32'b0;
    store_data = 32'b0;
    end
    endcase
end

endmodule