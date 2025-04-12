`include "ALU.v"
`include "ALUControlUnit.v"
`include "CACHE_Controller.v"
`include "ControlUnit.v"
`include "DataMemory.v"
`include "ImmGen.v"
`include "ProgramCounter.v"
`include "RegisterFile.v"
`include "InstructionMemory.v"
`include "SE.v"


`timescale 10ns/1ns

module scp_riscv (
    input wire clk,clk_cc, reset
);

    // Internal signals
   

    wire [31:0] instr, reg_read_data_1, reg_read_data_2, imm, ALUResult, MemData, reg_write_data;
    wire [4:0] rs1, rs2, rd;
    wire [3:0] ALUControl;
    wire [1:0] ALUop,ImmSel;
    wire reg_write_en, AluSrc, MemtoReg, MemRead, MemWrite, branch, zero;
    
    // Cache Controller Signals
    wire [31:0] output_data;
    wire hit1, hit2, Wait;
    wire [31:0] stored_address, stored_data;
    // Program Counter
    wire [31:0] pc, pc_next;
    
    pc program_counter (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .pc_out(pc)
    );

    // Next PC logic (simple increment for now)
    assign pc_next = pc + 4;

    // Instruction Memory
    instr_mem rom (.pc(pc), .instr(instr));

    // Decode Instruction
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd = instr[11:7];

    // Control Unit
    control_unit main_control_unit (
        .opcode(instr[6:0]), 
        .aluOP(ALUop),
        .reg_write_en(reg_write_en), 
        .ImmSel(ImmSel),
        .aluSrc(AluSrc),
        .MemtoReg(MemtoReg), 
        .MemRead(MemRead),
        .MemWrite(MemWrite), 
        .branch(branch)
    );

    assign stall = Wait;

    // Register File
    register_file reg_file (
        .clk(clk), 
        .reg_read_addr_1(rs1), 
        .reg_read_data_1(reg_read_data_1),
        .reg_read_addr_2(rs2), 
        .reg_read_data_2(reg_read_data_2),
        .reg_write_addr(rd), 
        .reg_write_en(reg_write_en), 
        .reg_write_data(reg_write_data)
    );

    // Immediate Generator
    Sign_Extend imm_gen (.in(instr), .imm_ext(imm),.ImmSrc(ImmSel));

    // ALU Control
    alu_control alu_ctrl (
        .aluOP(ALUop), 
        .funct3(instr[14:12]), 
        .funct7(instr[30]), 
        .aluControl(ALUControl)
    );

    // ALU
    wire [31:0] ALUop2 = AluSrc ? imm : reg_read_data_2;
    alu alu (
        .a(reg_read_data_1), 
        .b(ALUop2), 
        .alu_control(ALUControl), 
        .alu_result(ALUResult), 
        .zero_flag(zero)
    );

    // Cache Controller Integration
    CACHE_CONTROLLER cache (
        .address(ALUResult), 
        .clk_cc(clk_cc), 
        .data(reg_read_data_2), 
        .mode(MemWrite),
        .output_data(output_data), 
        .hit1(hit1), 
        .hit2(hit2), 
        .Wait(Wait),
        .stored_address(stored_address), 
        .stored_data(stored_data)
    );
wire [31:0] sign_extended_data; 

// Instantiate the sign extender
SE se_inst (
    .in(stored_data[7:0]), 
    .out(sign_extended_data)
);

    // Data Memory

    // Write Back
assign reg_write_data = (MemtoReg) ? sign_extended_data : ALUResult;




endmodule
