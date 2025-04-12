`timescale  10ns/1ns
module instr_mem
// IO ports
(
    input wire [31:0] pc, 
    input wire reset,
    output wire [31:0] instr
);

// internal signal declaration
reg [7:0] rom [(2**16)-1:0];
wire [31:0] rom_output;
integer i;

// programming ROM with instructions
// expected output after 5 cycles: r10 = 17  
initial
begin
        rom[0] = 8'b0;  rom[1] = 8'b0;  rom[2] = 8'b0;  rom[3] = 8'b0;
        rom[4] = 8'b0;  rom[5] = 8'b0;  rom[6] = 8'b0;  rom[7] = 8'b0;
        rom[8] = 8'b0;  rom[9] = 8'b0;  rom[10] = 8'b0; rom[11] = 8'b0;
        rom[12] = 8'b0; rom[13] = 8'b0; rom[14] = 8'b0; rom[15] = 8'b0;
        rom[16] = 8'b0; rom[17] = 8'b0; rom[18] = 8'b0; rom[19] = 8'b0;
        rom[20] = 8'b0; rom[21] = 8'b0; rom[22] = 8'b0; rom[23] = 8'b0;
        rom[24] = 8'b0; rom[25] = 8'b0; rom[26] = 8'b0; rom[27] = 8'b0;
        rom[28] = 8'b0; rom[29] = 8'b0; rom[30] = 8'b0; rom[31] = 8'b0;
        $readmemb("TEST_INSTRUCTIONS.dat", rom);
// add r1, r2, r3
//    rom[0]  = 8'b00000000;
//    rom[1]  = 8'b01100010;
//    rom[2]  = 8'b10000011;
//    rom[3]  = 8'b10110011
end
assign rom_output = {rom[pc], rom[pc+1], rom[pc+2], rom[pc+3]}; 
assign instr = rom_output;

endmodule
