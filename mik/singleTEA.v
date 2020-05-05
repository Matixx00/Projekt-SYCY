module singleTEA (
	input			clk,
	input			encrypt,	// 1 -> encrypt		0 -> decrypt
	
	input [127:0]	key,
	input [31:0]	inBlack,
					inRed,
					sum,	// suppplied from instantiating module - suitable for encryption or decryption
					
	output [31:0]	outBlack,
					outRed
);

	wire [31:0] black,
				red;
	wire [31:0] result1,
				result2;
				
	
	assign black = inBlack;
	
	
	functionF f1(
		.inKeyL(key[95:64]),
		.inKeyR(key[127:96]),
		.sum(sum),
		.chunk32(inBlack),
		.out32(result1)
	);
	
	assign red = encrypt ? inRed + result1 : inRed - result1 ;
	

	functionF f2(
		.inKeyL(key[31:0]),
		.inKeyR(key[63:32]),
		.sum(sum),
		.chunk32(red),
		.out32(result2)
	);
	
	assign outBlack = encrypt ? inBlack + result2 : inBlack - result2 ;
	assign outRed = red;

endmodule
