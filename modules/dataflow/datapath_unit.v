module datapath_unit(input clk,input jump,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write,bne,
	input [1:0] alu_op,output [3:0]opcode);
//jump is for indicating a jump
// beq is branching takes place 
//mem_read,mem_write for enabling memory read and write
//alu_src, if 1, gives the external address and 0 for data from second GPR 
//reg_dst is for selecting register destination bit
//mem_to_reg
//reg_write is the register write enable for the general purpose registers- 8 registers
//bne& bne are for enabling beq and bne
//opcode is the output which has the fucntion output 
reg [15:0] pc_current; //The current 16bit instruction address 
wire [15:0] pc_next,pc2;// pc_next for going to the next location after a jump
wire[15:0] instr; //for instruction which is currently executing
wire [2:0] reg_write_dest; //register number
wire [15:0] reg_write_data;  //16 bit data to be written to the GPRs
wire [2:0] reg_read_addr_1; //address for the GPRs
wire [15:0] reg_read_data_1; // This is the data read from GPRs
wire [2:0] reg_read_addr_2; //address for the GPRs
wire [15:0] reg_read_data_2; // This is the data read from GPRs
wire [15:0] ext_im,read_data2; //external reading of data
wire [2:0] ALU_Control; // For selecting the operation of the ALU
wire [15:0] ALU_out; // This is the output from the ALU unit
wire zero_flag; //ALU zero flag
wire [15:0] PC_j, PC_beq, PC_2beq,PC_bne,PC_2bne; // for handling the branching instructions
wire beq_control; // for handling the branching
wire [12:0] jump_shift;
wire [15:0] mem_read_data; //gives the data read from memory
//Program counter
initial begin
pc_current <= 16'd0; //this is done to make sure that the pc is only reset the first time the processor runs
end
always@(posedge clk)begin
pc_current <= pc_next;
end
assign pc2 = pc_current + 16'd2; // This adds 2 more to the current pc address
//Instrution memory
intruction_memory im(.pc(pc_current),.instruction(instr));
//Jump shift left once
assign jump_shift = {instr[11:0],1'b0}; //Shifting the instr by once to the left
// multiplexer regdest
assign reg_write_dest = (reg_dst==1'b1)?instr[5:3]: instr[8:6];
/*
The reg_dst signal is used to multiplex between different data going from the
16 bit instruction
*/
// Register file 
assign reg_read_addr_1 = instr[11:9];
assign reg_read_addr_2 = instr[8:6];
// General purpose registers(GPRs)
GPRs reg_file(
	.clk(clk),
	.reg_write_en(reg_write),
	.reg_write_dest(reg_write_dest),
	.reg_write_data(reg_write_data),
	.reg_read_addr1(reg_read_addr_1),
	.reg_read_data1(reg_read_data_1),
	.reg_read_addr2(reg_read_addr_2),
	.reg_read_data2(reg_read_data_2));
// immediate extend
assign ext_im = {{10{instr[5]}},instr[5:0]}; // this is for extending the instruction 
// ALU control unit
alu_control alu_ctrl(.ALU_Cnt(ALU_Control),.ALUOp(alu_op),.Opcode(instr[15:12]));
//The ALU_Control is the 3 bit data for selection of operation
//alu_op is the two bit added in the alu control unit
//opcode is the operation code

//Multiplexer alu_src
assign read_data2 = (alu_src==1'b1) ? ext_im : reg_read_data_2;
// ALU UNIT 
alu alu_unit(.x(reg_read_data_1),.y(read_data2),.alu_control(ALU_Control),.res(ALU_out),.zero_flag(zero_flag));
// PC beq add
assign pc_beq = pc2 + {ext_im[14:0],1'b0}; // This adds to the branch statement in the instructions
assign pc_bne = pc2 + {ext_im[14:0],1'b0};
//beq control
assign beq_control = beq & zero_flag;
assign bne_control = bne & (~zero_flag);
//PC_beq
assign PC_2beq = (beq_control==1'b1) ? PC_beq : pc2;
// PC_bne 
assign PC_2bne = (bne_control==1'b1) ? PC_bne : PC_2beq;
// PC_j
assign PC_j = {pc2[15:13],jump_shift};
//PC_next
assign pc_next = (jump ==1'b1)?PC_j:PC_2bne;

//Data memory
data_memory dm(
	.clk(clk),
	.mem_write_data(reg_read_data_2),
	.mem_access_addr(ALU_out),
	.mem_write_en(mem_write),
	.mem_read(mem_read),
	.mem_read_data(mem_read_data));
// Write back from memory to register
assign reg_write_data = (mem_to_reg==1'b1)? mem_read_data: ALU_out;
//output to control unit
assign opcode = instr[15:12];
endmodule 
