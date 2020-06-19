`timescale 1ns/1ps
module risc_16(input clk);
wire jump,bne,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write;
wire [1:0] alu_op;
wire [3:0] opcode;
//Configuring the datapath 
datapath_unit DU(.clk(clk),.jump(jump),
	.beq(beq),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.alu_src(alu_src),
	.reg_dst(reg_dst),
	.mem_to_reg(mem_to_reg),
	.reg_write(reg_write),
	.bne(bne),
	.alu_op(alu_op),
	.opcode(opcode));
//control_unit
control_unit CU(.opcode(opcode),
  .reg_dst(reg_dst),
  .mem_to_reg(mem_to_reg),
  .alu_op(alu_op),
  .jump(jump),
  .bne(bne),
  .beq(beq),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_write(reg_write));
endmodule
