module writeback_stage(
    input wire [31:0] MEMWB_LoadData,
    input wire [31:0] MEMWB_AluRES,
    input wire [4:0] MEMWB_rd,
    input wire MEMWB_WriteBack,
    input wire MEMWB_U_UJ_Load,
    input wire [31:0] MEMWB_U_UJ_Load_val,
    output reg [31:0] MEMWB_WriteBack_Val
);
always @(*) begin
    if(MEMWB_WriteBack) begin
        MEMWB_WriteBack_Val = MEMWB_AluRES;
    end
    else if (MEMWB_U_UJ_Load) begin
        MEMWB_WriteBack_Val = MEMWB_U_UJ_Load_val;
    end
    else begin
        MEMWB_WriteBack_Val = MEMWB_LoadData;
    end
end
endmodule