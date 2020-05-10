module modulik(
	input			clk, ena, rst,	// standard controlls
					encrypt,		// should we encrypt?
	input	[ 63:0]	inBlock64,		// a 64 bit block to process
	input	[127:0]	key,			// key for en/decryption
	
	output	[ 63:0]	outBlock64		// processed 64 bit block
);

	localparam DELTA = 32'h9e37_79b9;	// from TEA specs    (sqrt(5)-1) * 2^31

	wire [63:0] from_enc_to_dec;

	full_encryptor Enc1 (
		.inBlock64(inBlock64),
		.key(key),
		.outBlock64(from_enc_to_dec)
	);
	
	full_decryptor Dec1 (
		.inBlock64(from_enc_to_dec),
		.key(key),
		.outBlock64(outBlock64)		
	);

	
endmodule
