module forwarding_unit(
    input wire [4:0] IDEX_rs1,
    input wire [4:0] IDEX_rs2,
    input wire [4:0] EXMEM_rd,
    input wire [4:0] MEMWB_rd,
    input wire EXMEM_WriteBack,
    input wire MEMWB_WriteBack,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin

    //forward From DataMemory Stage
    if(EXMEM_WriteBack) begin
        if(EXMEM_rd == IDEX_rs1) begin
            forwardA = 2'b10;
        end 
        if(EXMEM_rd == IDEX_rs2) begin
            forwardB = 2'b10;
        end
    end  

    //forward From WriteBack Stage
    if(MEMWB_WriteBack) begin
        if(MEMWB_rd == IDEX_rs1) begin
            forwardA = 2'b01;
        end 
        if(MEMWB_rd == IDEX_rs2) begin
            forwardB = 2'b01;
        end
    end  

    else begin
        forwardA = 2'd0;
        forwardB = 2'd0;
    end
end

endmodule