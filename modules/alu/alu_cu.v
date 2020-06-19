`timescale 1ns/1ps
module alu_control(output reg[2:0]ALU_Cnt, input[1:0]ALUOp, input[3:0]Opcode);
// The Opcode is 4 bit, as the numebr of instructions is 15
wire[5:0] ALUControlIn;
assign ALUControlIn = {ALUOp,Opcode}; // This concatenates the 4 bits of opcode and 2 bits of ALUOp
always@(ALUControlIn) begin 
casex(ALUControlIn)
6'b10xxxx: ALU_Cnt=3'b000;
6'b01xxxx: ALU_Cnt=3'b001;
6'b000010: ALU_Cnt=3'b000;
6'b000011: ALU_Cnt=3'b001;
6'b000100: ALU_Cnt=3'b010;
6'b000101: ALU_Cnt=3'b011;
6'b000110: ALU_Cnt=3'b100;
6'b000111: ALU_Cnt=3'b101;
6'b001000: ALU_Cnt=3'b110;
6'b001001: ALU_Cnt=3'b111;
default: ALU_Cnt=3'b000;
endcase 
end
endmodule
//output ALU_Cnt