module singleTEA (
	input			clk,
	input			encrypt,	// 1 -> encrypt		0 -> decrypt
	
	input	[127:0]	key,
	input	[ 31:0]	inFirst,
					inSecond,
					sum,	// suppplied from instantiating module - suitable for encryption or decryption
					
	output	[ 31:0]	outFirst,
					outSecond
);



	wire [31:0] first,
				second;
	wire [31:0] result1,
				result2;
				
	
	assign first = inFirst;
	
	
	functionF f1(
		.inKeyL( encrypt	? key[ 31: 0]		// k[0]
							: key[ 95:64] ),	// k[2]
		.inKeyR( encrypt	? key[ 63:32]		// k[1]
							: key[127:96] ),	// k[3]
		.sum(sum),
		.chunk32(first),
		.out32(result1)
	);
	
	assign second = encrypt ? inSecond + result1 : inSecond - result1;
	

	functionF f2(
		.inKeyL( encrypt	? key[ 95:64]		// k[2]
							: key[ 31: 0] ),	// k[0]
		.inKeyR( encrypt	? key[127:96]		// k[3]
							: key[ 63:32] ),	// k[1]
		.sum(sum),
		.chunk32(second),
		.out32(result2)
	);
	
	assign outFirst = encrypt ? inFirst + result2 : inFirst - result2;
	assign outSecond = second;

	
	
endmodule
