/*
 * Two decryptors.
 * One combinational, other synchronized.
 * Take same input, output should be the same for both.
 *
 */


module decryptor_test (
	input			clk, ena, rst,		// standard controlls
	input	[ 63:0]	inBlock64,			// a 64 bit block to process
	input	[127:0]	key,				// key for en/decryption
	
	output	[ 63:0]	outBlock64_sync	// processed 64 bit block
//	output	[ 63:0]	outBlock64_async	// processed 64 bit block
);


	// ======================= Testing slow clock generator:
/*	wire 			slow_clk;
	reg		[7:0]	clk_split;

	clock_divider div0 (
		.clk		(clk),
		.ena		(ena),
		.rst		(rst),
		.div_clk	(slow_clk)
	);

	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			clk_split <= 8'b0;
		end
		else if (ena) begin
			clk_split <= {clk_split[6:0], slow_clk};
		end
	end
	*/
	// ======================= End slow clock generator
	
	reg		[9:0]	clk_sim;	// clock simulator - just a rotating register
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			clk_sim <= 10'b00_0001_1111;
		end
		else if (ena) begin
			clk_sim <= {clk_sim[8:0], clk_sim[9]};
		end
	end
	
	
// Synchronized decryptor.
// After a number of clock cycles we get the plain text.
	faster_sync_decryptor s_dec(
		.clk		(clk_sim[0]),	// slow clock
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(outBlock64_sync)
	);


// Combinational decryptor.
// Result should be the same as from synchronized decryptor.
//	full_comb_decryptor c_dec(
//		.inBlock64(inBlock64),
//		.key(key),
//		.outBlock64(outBlock64_async)			
//	);


endmodule
