module DMI(
    input wire [31:0]load,
    input wire [5:0]aluOP,
    output reg [31:0]load_data
);
localparam loadByte = 6'd0;
localparam loadHalf = 6'd1;
localparam loadByteUnsigned = 6'd3;
localparam loadHalfUnsigned = 6'd4;
localparam loadWord = 6'd2;

wire [7:0]LB;
wire [15:0]LH;
wire [7:0]LBU;
wire [15:0]LHU;
wire [31:0]LW;

assign LB = load[7:0];
assign LH = load[15:0];
assign LBU = load[7:0];
assign LHU = load[15:0];
assign LW = load[31:0];

always @(*) begin
    case(aluOP)
    loadByte: begin
        load_data = $signed({{24{LB[7]}},LB}); // load bite
    end
    loadHalf: begin
        load_data = $signed({{16{LH[15]}},LH}); // load half bite
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
    endcase
end

endmodule