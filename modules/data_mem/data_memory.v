`timescale 1ns/1ps
`include "parameter.v" // For including the parameters of the processor
module data_memory(input clk, input [15:0] mem_access_addr, input [15:0] mem_write_data, input mem_write_en, input mem_read, output [15:0]mem_read_data );
reg [`col-1:0] memory[`row_d-1:0]; // Memory arrary for the data to be stored
integer f;
wire[2:0] ram_addr = mem_access_addr[2:0]; // Specifies the ram address for accessing the data 
initial begin 
$readmemb("./test/test.data",memory);
f = $fopen(`filename); // Opens the file given in the parameter.v
$fmonitor(f,"time = %d\n",$time,
"\tmemory[0] = %b\n",memory[0],
"\tmemory[0] = %b\n",memory[1],
"\tmemory[0] = %b\n",memory[2],
"\tmemory[0] = %b\n",memory[3],
"\tmemory[0] = %b\n",memory[4],
"\tmemory[0] = %b\n",memory[5],
"\tmemory[0] = %b\n",memory[6],
"\tmemory[0] = %b\n",memory[7]); // This monitors the states of the data memory and displays it everytime the memory content changes, and also displays the time 
`simulation_time; // For making the program stall for the specified simulation time 
$fclose(f);
end
always@(posedge clk) begin
if (mem_write_en==1)
memory[ram_addr] <= mem_write_data; //mem write
end
assign mem_read_data = (mem_read==1'b1)?memory[ram_addr]:16'd0; // mem read
endmodule
