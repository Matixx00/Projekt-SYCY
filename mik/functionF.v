module functionF (
	//input			clk,
	input [31:0]	inKeyL, inKeyR,
	input [31:0]	sum,
	input [31:0]	chunk32,
	output [31:0]	out32
);

	reg [31:0] out_reg;

	always@(*)
		out_reg  <= ( (chunk32 << 4 + inKeyL) ^ (chunk32 + sum) ^ (chunk32 >> 5 + inKeyR) );
		
	assign out32 = out_reg;		

endmodule
