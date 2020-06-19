`timescale 1ns/1ps
module GPRs(input clk,input reg_write_en, input [2:0]reg_write_dest, input [15:0]reg_write_data, input [2:0]reg_read_addr1,
             output [15:0]reg_read_data1,input [2:0]reg_read_addr2,output [15:0]reg_read_data2 );
reg [15:0] reg_array [7:0]; // 8 16bit registers are assigned 
integer i;
// The reg_write_addr1 and 2 can address the 8 registers inside the reg_array
initial begin
for(i=0;i<8;i=i+1)
reg_array[i] <=16'd0; // Initializes the registers to zero
end
always@(posedge clk)begin
	if(reg_write_en==1)begin
	reg_array[reg_write_dest]<= reg_write_data;
	end
end
assign reg_read_data1=reg_array[reg_read_addr1];
assign reg_read_data2=reg_array[reg_read_addr2];
endmodule
