`timescale  10ns/1ns
// Imm select and sign extend
module Sign_Extend(in,imm_ext,ImmSrc);

input [31:0] in;
output [31:0] imm_ext;
input [1:0] ImmSrc;
 
assign imm_ext = (ImmSrc==2'b01) ? {{20{in[31]}}, in[31:25], in[11:7]} :  // S-type
                 (ImmSrc==2'b00) ? {{20{in[31]}}, in[31:20]} :  // I-type
                 (ImmSrc==2'b10) ? {{19{in[31]}}, in[31], in[7], in[30:25], in[11:8], 1'b0} :  // B-type (note the different sign extension)
                 {{12{in[31]}}, in[19:12], in[20], in[30:21], 1'b0};  // J-type
endmodule