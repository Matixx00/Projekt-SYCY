module decryptor_test (
	input			clk, ena, rst,		// standard controlls
	input	[ 63:0]	inBlock64,			// a 64 bit block to process
	input	[127:0]	key,				// key for en/decryption
	
	output	[ 63:0]	outBlock64	// processed 64 bit block
);


// Synchronized decryptor.
// After a number of clock cycles we get the plain text.
	full_sync_decryptor s_dec(
		.clk(clk),
		.ena(ena),
		.rst(rst),
		.inBlock64(inBlock64),
		.key(key),
		.outBlock64(outBlock64)
	);

endmodule
