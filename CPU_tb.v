`include "CPU.v"
`timescale  10ns/1ns

module cpu_tb;

// signal declaration
reg clk, clk_cc, reset;
wire [31:0] testing;

// DUT instantiation
scp_riscv dut 
(.clk(clk), 
.clk_cc(clk_cc),
.reset(reset)
);

//// body
//initial
//begin
//    $monitor("time: %d", $time," pc = %d r1 = %d, r4 = %d, r10 = %d, ram[6] = %d",
//            dut.pc_out, dut.reg_file.reg_file[1], dut.reg_file.reg_file[4],
//            dut.reg_file.reg_file [10], dut.ram.ram[6]);
//end

initial
begin
    clk = 1;
    clk_cc=1;
    reset = 1;
    #2
    reset = 0;

    // Dumpfile and dumpvars
    $dumpfile("cpu_tb.vcd");       // VCD file name
    $dumpvars(1, cpu_tb);   // Only top level
    $dumpvars(1, dut);      // Only top-level of DUT
    #3000;                // Shorter simulation time
    $finish;
end


// clock signal generation
always  #42 clk = ~clk;
always #1 clk_cc = ~clk_cc;



// wire mappings for observation
wire [31:0] x5, x6, x7;
wire [31:0] pc, instr;
wire [4:0]  rd1;
wire [3:0]  aluctl;
wire [31:0] rs1, rs2, wr_dat, alu2, alures;

assign rs1     = dut.reg_file.reg_read_data_1;
assign rs2     = dut.reg_file.reg_read_data_2;
assign rd1     = dut.reg_file.reg_write_addr;
assign alu2    = dut.ALUop2;
assign aluctl  = dut.alu_ctrl.aluControl;
assign alures  = dut.alu.alu_result;
assign wr_dat  = dut.reg_write_data;
assign instr   = dut.rom.instr;
assign pc      = dut.program_counter.pc_out;
assign x5      = dut.reg_file.reg_file[5];
assign x6      = dut.reg_file.reg_file[6];
assign x7      = dut.reg_file.reg_file[7];

endmodule
