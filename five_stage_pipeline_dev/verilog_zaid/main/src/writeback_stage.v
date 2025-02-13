module writeback_stage(
    input wire [31:0] MEMWB_LoadData,
    input wire [31:0] MEMWB_AluRES,
    input wire [4:0] MEMWB_rd,
    input wire MEMWB_WriteBack,
    output reg [31:0] MEMWB_WriteBack_Val
);
always @(*) begin
    if(MEMWB_WriteBack) begin
        MEMWB_WriteBack_Val = MEMWB_AluRES;
    end
    else begin
        MEMWB_WriteBack_Val = MEMWB_LoadData;
    end
end
endmodule