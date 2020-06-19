module alu(input [15:0]x, input[15:0]y, input [2:0]alu_control,
		output reg [15:0] res,output zero_flag);
always@(*)begin
case(alu_control)
3'b000: res = x+y;//addition
3'b001: res= x-y; //subtraction
3'b010: res = ~x; //bit-wise invertion
3'b011: res = x<<y; // LSL
3'b100: res = x>>y; // LSR
3'b101: res = x & y; //bit-wise AND 
3'b110: res = x | y; //bit-wise OR
3'b111: begin if(x<y) res=16'd1;
		else res=16'd0;
	end
default: res = x+y;
endcase
end
assign zero = (res == 16'd0)?1'b1:1'b0; // This is the zero flag
endmodule

