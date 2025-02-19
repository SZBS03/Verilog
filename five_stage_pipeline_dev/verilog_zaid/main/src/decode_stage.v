
`include "src/registerfile.v"

module decode_stage(
input wire clk,
input wire [31:0] PC,
input wire [31:0] instruction,
input wire [31:0] MEMWB_WriteBack_val,
input wire  IDEX_MemoryRead,
input wire [4:0] MEMWB_rd,
input wire [4:0] IDEX_rd,
input wire MEMWB_WriteBack, 
output reg [4:0] IFID_rs1,
output reg [4:0] IFID_rs2,
output reg [4:0] IFID_rd,
output reg [31:0] IFID_imm,
output wire [31:0] IFID_read_data1,
output wire [31:0] IFID_read_data2,
output reg [31:0] branchPC,
output reg [31:0] U_UJ_Load_val,
output reg WriteBack, //IFID_WriteBack
output reg MemoryRead, //IFID_MemoryRead
output reg MemoryWrite, //IFID_MemoryWrite
output reg [3:0] aluOP, //IFID_aluOP
output reg [1:0] aluOP_2, //IFID_aluOP_2
output reg AluSrc, //IFID_AluSrc
output reg PCWrite,
output reg IFIDWrite,
output reg IF_flush,
output reg Execution,
output reg branch,
output reg U_UJ_Load
);

// instr decode
wire [6:0] opcode = instruction[6:0];
wire [2:0] func3 = instruction[14:12];
wire [6:0] func7 = instruction[31:25];
wire [4:0] rd  = instruction[11:7];
wire [4:0] rs1 = instruction[19:15];
wire [4:0] rs2 = instruction[24:20]; 
reg rst;
reg ID_flush;
reg HDU;
reg jalrEN;
reg jalEN;
reg luiEN;
reg auipcEN;
reg [11:0] split_inst;
reg [20:0] split_inst2;
reg [12:0] split_inst3;


initial begin
    HDU = 0;
    rst = 0;
    IF_flush = 0;
    ID_flush = 0;
    branch = 0;
    U_UJ_Load = 0;
    WriteBack = 0;
    IFIDWrite = 1;
    Execution = 1;
    PCWrite = 1;
end

// Immediate generation logic
always @(*) begin
    //default values
    IFID_rs1 = rs1;
    IFID_rs2 = rs2;
    IFID_rd = rd;
    aluOP_2 = 2'bxx;
    aluOP = 4'bxxxx;

    case (opcode)
        7'b0000011, 7'b0010011, 7'b1100111: begin
            IFID_imm = {{20{instruction[31]}}, instruction[31:20]};  //laod , alu_i-type and jalr_i-type
        end
        7'd35: begin   
            split_inst [4:0] = instruction [11:7];
            split_inst [11:5] = instruction [31:25];             //store instruction 
            IFID_imm = {{20{split_inst[11]}}, split_inst};
        end
        7'd23 , 7'd55: begin                                //auipc and lui U-type
            IFID_imm = {instruction[31:12], 12'b0};
        end
        7'd111: begin                               //jal-UJ
            split_inst2 [0] = 1'b0;
            split_inst2 [20] = instruction [31];
            split_inst2 [11] = instruction [20];
            split_inst2 [10:1] = instruction [30:21];
            split_inst2 [19:12] = instruction [19:12];
            IFID_imm = {{11{split_inst2[20]}}, split_inst2};
        end
        7'd99: begin                        //branch SB-type
            split_inst3 [0] = 1'b0;
            split_inst3 [4:1] = instruction [11:8];
            split_inst3 [10:5] = instruction [30:25];
            split_inst3 [11] = instruction [7];
            split_inst3 [12] = instruction [31];
            IFID_imm = {{19{split_inst3[12]}}, split_inst3};
        end
        default: begin
            IFID_imm = 32'bxxxx;
        end
    endcase
end

//hazard detection unit 
always @(*) begin
    if(IDEX_MemoryRead && (IDEX_rd == IFID_rs1 || IDEX_rd == IFID_rs2)) begin // load hazard control
        HDU = 1;
        IFIDWrite = 0;
        PCWrite = 0;
    end
end

//Instantiate register file
register u_register (
    .clk(clk),
    .reset(rst),
    .regWrite(MEMWB_WriteBack), 
    .write_data(MEMWB_WriteBack_val),
    .rd_data(MEMWB_rd),
    .rs1_data(rs1),
    .rs2_data(rs2),
    .read_data1(IFID_read_data1),
    .read_data2(IFID_read_data2)
);


// control unit
always @(*) begin
    HDU = 0;
    rst = 0;
    branch = 0;
    U_UJ_Load = 0;
    IFIDWrite = 1;
    Execution = 1;
    PCWrite = 1;
    WriteBack = 0;
    MemoryRead = 0;
    MemoryWrite = 0;
    ID_flush = 0;
    IF_flush = 0;
    AluSrc = 0;
    jalrEN = 0;
    jalEN = 0;
    luiEN = 0;
    auipcEN = 0;
    branchPC = 32'bxxxx;

    case (opcode)
        7'd51 , 7'd19: begin // ALU operation R-type and I-type
            case (func3)
                3'd0: aluOP = func7[5] ? 4'd3 : 4'd2;  // SUB or ADD/ADDI
                3'd1: aluOP = 4'd8;  // SLL/SLLI
                3'd2: aluOP = 4'd4;  // SLT/STLI
                3'd3: aluOP = 4'd5;  // SLTU/SLTIU
                3'd4: aluOP = 4'd6;  // XOR/XORI
                3'd5: aluOP = func7[5] ? 4'd9 : 4'd10;  // SRA/SRAI or SRL/SRLI
                3'd6: aluOP = 4'd1;  // OR/ORI
                3'd7: aluOP = 4'd0;  // AND/ANDI
            endcase
            if(opcode == 7'd19) begin
            AluSrc = 1;
            end
            WriteBack = 1;
        end
        7'd3,7'd35: begin
            case (func3)
                3'd0: aluOP_2 = 2'd0;  // LB/SB
                3'd1: aluOP_2 = 2'd1;  // LH/SH
                3'd4: aluOP_2 = 2'd2;  // LBU
                3'd5: aluOP_2 = 2'd3;  // LHU
                3'd2: aluOP_2 = 2'bxx;  // LW/SW
            endcase

        if(opcode == 7'd3) begin
            MemoryRead = 1;
            MemoryWrite = 0;
        end
        
        if(opcode == 7'd35) begin
            MemoryRead = 0;
            MemoryWrite = 1;
        end
        aluOP = 4'd2; // Address calculation
        AluSrc = 1;
        end

        7'd103: begin   //jalr
            jalrEN = 1;
            AluSrc = 1;
            U_UJ_Load = 1;
            U_UJ_Load_val = PC + 4;
            branch= 1;
        end

        7'd23: begin        //AUIPC
            auipcEN = 1;
            U_UJ_Load_val = PC + IFID_imm;
            U_UJ_Load = 1;
        end

        7'd55: begin        //LUI
            luiEN = 1;
            U_UJ_Load_val = IFID_imm;
            U_UJ_Load = 1;
        end 

        7'd111: begin       //jal
            jalEN = 1;
            AluSrc = 1;
            branch= 1;
            U_UJ_Load_val = PC + 4;
            U_UJ_Load = 1;
            branch= 1;
        end

        7'd99: begin        //branch
            case (func3)
                3'd0: aluOP = 4'd7; // beq 
                3'd1: aluOP = 4'd11; // bne
                3'd4: aluOP = 4'd12; // blt
                3'd5: aluOP = 4'd13; // bge
                3'd6: aluOP = 4'd14; // bltu
                3'd7: aluOP = 4'd15; // bgeu
            endcase
            AluSrc = 1;
        end
    endcase

    case(aluOP) // branch alu operation
        4'd7:  if (IFID_read_data1 == IFID_read_data2) begin
            branch= 1;
            end
        4'd11: if (IFID_read_data1 != IFID_read_data2) begin
            branch= 1;
            end
        4'd12: if (IFID_read_data1 < IFID_read_data2) begin
            branch= 1;
            end
        4'd13: if (IFID_read_data1 > IFID_read_data2) begin
            branch= 1;
            end
        4'd14: if (IFID_read_data1 < IFID_read_data2) begin
            branch= 1;
            end
        4'd15: if (IFID_read_data1 >= IFID_read_data2) begin
            branch= 1;
            end
    endcase

    if(branch || jalEN || jalrEN) begin        //ID AND IF Flush will be high when the branch is taken
        branchPC = (jalrEN) ? IFID_read_data1 + IFID_imm : IFID_imm + PC; //jalr and branch select
        PCWrite = 0;
        ID_flush = 1;
        IF_flush = 1;
    end

    if(HDU || ID_flush) begin // branch detection hazard control
        WriteBack = 0;              //stalling write back stage
        MemoryRead = 0;             //stalling memory stage 
        MemoryWrite = 0;            //stalling memory stage 
        Execution = 0;              //stalling execution stage 
    end

end

endmodule

