`timescale 1ns/1ps
`include "parameter.v"
module test_bench();
//inputs
reg clk;
risc_16 uut(.clk(clk)); //unit under test

initial begin
clk<=0;
`simulation_time;
$finish;
end
always begin
#5 clk=~clk; //100MHz
end
endmodule
