/*
 * Single running round of TEA
 * For debugging
 */

module one_round_test(
	input			clk, ena, rst,	// standard controlls
					encrypt,		// should we encrypt?
	input	[ 63:0]	inBlock64,		// a 64 bit block to process
	input	[127:0]	key,			// key for en/decryption
	output	[ 63:0]	outBlock64		// processed 64 bit block
);

	localparam PDF_PLAIN_HEADER			= 64'h2550_4446_2D31_2E35;	// %PDF-1.5
	localparam PDF_PLAIN_HEADER_1		= 32'h2550_4446;	// %PDF
	localparam PDF_ENCRYPTED_HEADER_1	= 32'h42c3_7893;
	localparam PDF_PLAIN_HEADER_2		= 32'h2D31_2E35;	// -1.5
	localparam PDF_ENCRYPTED_HEADER_2	= 32'hfbc2_d912;
	localparam DECRYPT_SUM_0		 	= 32'hc6ef_3720;	// need this for decryption - from TEA specs == DELTA × 32
	localparam DELTA					= 32'h9e37_79b9;	// from TEA specs
	localparam KEY						= 128'h4875_6c6b_2069_7320_7468_616c_616d_6963;	// Hulk is thalamic
										// == 128'b1001000011101010110110001101011001000000110100101110011001000000111010001101000011000010110110001100001011011010110100101100011
	
	

/*
 * First round of TEA.
 * Input for processing is from top level input inBlock64.
 * Output goes on the output of the top-level module.
 */
	wire [31:0] red1, black1;
	
	
	singleTEA tea1 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inBlack(inBlock64[31:0]),
		.inRed(inBlock64[63:32]),
		.sum (
			encrypt ? DELTA*1 : DELTA*32
		),
		.outBlack(outBlock64[31:0]),
		.outRed(outBlock64[63:32])
	);


	
endmodule
