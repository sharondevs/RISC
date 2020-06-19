`include  "parameter.v"
//The above parameter defines the diffrent parameter's of the processor like the memory count, the instruction count, 
// the bit size of the processor and so on.
module intruction_memory(input [15:0] pc, output [15:0]instruction);
reg [`col-1:0] memory [`row_i-1:0];
wire [3:0]rom_addr = pc[4:1];
initial begin
$readmemb("./test/test.prog", memory,0,14);
end
assign instruction = memory[rom_addr];
endmodule
/*
The instruction memory module takes the program counter addr as input and give the 
instruction as output.
The mpdule creates a memory array,of word length and having a space of 14 to accomodate the 
instructions for the processor. 
The instruction count can we altered inaccordance with the user. 
The instruction addressed by the pc, is taken from the memory by the address present in pc.
*/