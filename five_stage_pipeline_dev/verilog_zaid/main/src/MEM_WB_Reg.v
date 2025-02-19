module MEMWBRegister (
    input wire  clk,
    input wire [31:0] EXMEM_LoadData,
    input wire [31:0] EXMEM_AluRES,
    input wire [4:0] EXMEM_rd,
    input wire EXMEM_WriteBack,
    input wire [31:0] EXMEM_U_UJ_Load_val,
    input wire EXMEM_U_UJ_Load,

    output reg [31:0] MEMWB_LoadData,
    output reg [31:0] MEMWB_AluRES,
    output reg [4:0] MEMWB_rd,
    output reg MEMWB_WriteBack,
    output reg [31:0] MEMWB_U_UJ_Load_val,
    output reg MEMWB_U_UJ_Load
);

reg [31:0] MEMWB [0:5];

always @(posedge clk ) begin
    //read
    MEMWB [0] = EXMEM_LoadData;
    MEMWB [1] = EXMEM_AluRES;
    MEMWB [2] = EXMEM_rd;
    MEMWB [3] = EXMEM_WriteBack;
    MEMWB [4] = EXMEM_U_UJ_Load_val;
    MEMWB [5] = EXMEM_U_UJ_Load;
    //write 
    MEMWB_LoadData <= MEMWB [0];
    MEMWB_AluRES <= MEMWB [1];
    MEMWB_rd <= MEMWB [2];
    MEMWB_WriteBack <= MEMWB [3];
    MEMWB_U_UJ_Load_val <= MEMWB [4];
    MEMWB_U_UJ_Load <= MEMWB [5];
end


endmodule