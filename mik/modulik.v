module modulik(
	input			clk, ena, rst,	// standard controlls
					encrypt,		// should we encrypt?
	input [63:0]	inBlock64,		// a 64 bit block to process
	input [127:0]	key,			// key for en/decryption
	output [63:0]	outBlock64		// processed 64 bit block
);

	localparam PDF_PLAIN_HEADER_1		= 32'h2550_4446;	// %PDF
	localparam PDF_ENCRYPTED_HEADER_1	= 32'h42c3_7893;
	localparam PDF_PLAIN_HEADER_2		= 32'h2d31_2e36;	// -1.6
	localparam PDF_ENCRYPTED_HEADER_2	= 32'hfbc2_d912;
	localparam DECRYPT_SUM_0		 	= 32'hc6ef_3720;	// need this for decryption - from TEA specs == DELTA × 32
	localparam DELTA					= 32'h9e37_79b9;	// from TEA specs
	localparam KEY						= 128'h4875_6c6b_2069_7320_7468_616c_616d_6963;	// Hulk is thalamic
										// == 128'b1001000011101010110110001101011001000000110100101110011001000000111010001101000011000010110110001100001011011010110100101100011
	
	

/*
 * First round of TEA.
 * Input for processing is from top level input inBlock64.
 * Output goes on the wire, to be iput into the 2nd round of TEA.
 */
	wire [31:0] red1, black1;
	
	singleTEA tea1 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(inBlock64[63:32]),
		.inSecond(inBlock64[31:0]),
		.sum (
			encrypt ? 32'h9e37_79b9	//DELTA*1
					: 32'hc6ef_3720	//DELTA*32
		),
		.outFirst(black1),
		.outSecond(red1)
	);


/*
 * 2nd round of TEA.
 * Input is from previous round on the previous wire.
 * Output is on new wire for the following round.
 */
	wire [31:0] red2, black2;
	
	singleTEA tea2 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black1),
		.inSecond(red1),
		.sum (
			encrypt ? 32'h3c6e_f372	//DELTA*2
					: 32'h28b7_bd67	//DELTA*31
		),
		.outFirst(black2),
		.outSecond(red2)
	);
	
	
// Round 3:
	wire [31:0] red3, black3;
	
	singleTEA tea3 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black2),
		.inSecond(red2),
		.sum (
			encrypt ? 32'hdaa6_6d2b	//DELTA*3
					: 32'h8a80_43ae	//DELTA*30
		),
		.outFirst(black3),
		.outSecond(red3)
	);
	
	
// Round 4:
	wire [31:0] red4, black4;
	
	singleTEA tea4 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black3),
		.inSecond(red3),
		.sum (
			encrypt ? 32'h78dd_e6e4	//DELTA*4
					: 32'hec48_c9f5	//DELTA*29
		),
		.outFirst(black4),
		.outSecond(red4)
	);
	
	
// Round 5:
	wire [31:0] red5, black5;
	
	singleTEA tea5 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black4),
		.inSecond(red4),
		.sum (
			encrypt ? 32'h1715_609d	//DELTA*5
					: 32'h4e11_503c	//DELTA*28
		),
		.outFirst(black5),
		.outSecond(red5)
	);
	
	
// Round 6:
	wire [31:0] red6, black6;
	
	singleTEA tea6 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black5),
		.inSecond(red5),
		.sum (
			encrypt ? 32'hb54c_da56	//DELTA*6
					: 32'hafd9_d683	//DELTA*27
		),
		.outFirst(black6),
		.outSecond(red6)
	);
	
	
// Round 7:
	wire [31:0] red7, black7;
	
	singleTEA tea7 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black6),
		.inSecond(red6),
		.sum (
			encrypt ? 32'h5384_540f	//DELTA*7
					: 32'h11a2_5cca	//DELTA*26
		),
		.outFirst(black7),
		.outSecond(red7)
	);
	
	
// Round 8:
	wire [31:0] red8, black8;
	
	singleTEA tea8 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black7),
		.inSecond(red7),
		.sum (
			encrypt ? 32'hf1bb_cdc8	//DELTA*8
					: 32'h736a_e311	//DELTA*25
		),
		.outFirst(black8),
		.outSecond(red8)
	);
	
	
// Round 9:
	wire [31:0] red9, black9;
	
	singleTEA tea9 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black8),
		.inSecond(red8),
		.sum (
			encrypt ? 32'h8ff3_4781	//DELTA*9
					: 32'hd533_6958	//DELTA*24
		),
		.outFirst(black9),
		.outSecond(red9)
	);
	
	
// Round 10:
	wire [31:0] red10, black10;
	
	singleTEA tea10 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black9),
		.inSecond(red9),
		.sum (
			encrypt ? 32'h2e2a_c13a	//DELTA*10
					: 32'h36fb_ef9f	//DELTA*23
		),
		.outFirst(black10),
		.outSecond(red10)
	);
	
	
// Round 11:
	wire [31:0] red11, black11;
	
	singleTEA tea11 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black10),
		.inSecond(red10),
		.sum (
			encrypt ? 32'hcc62_3af3	//DELTA*11
					: 32'h98c4_75e6	//DELTA*22
		),
		.outFirst(black11),
		.outSecond(red11)
	);
	
	
// Round 12:
	wire [31:0] red12, black12;
	
	singleTEA tea12 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black11),
		.inSecond(red11),
		.sum (
			encrypt ? 32'h6a99_b4ac	//DELTA*12
					: 32'hfa8c_fc2d	//DELTA*21
		),
		.outFirst(black12),
		.outSecond(red12)
	);
	
		
// Round 13:
	wire [31:0] red13, black13;
	
	singleTEA tea13 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black12),
		.inSecond(red12),
		.sum (
			encrypt ? 32'h08d1_2e65	//DELTA*13
					: 32'h5c55_8274	//DELTA*20
		),
		.outFirst(black13),
		.outSecond(red13)
	);
	
	
// Round 14:
	wire [31:0] red14, black14;
	
	singleTEA tea14 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black13),
		.inSecond(red13),
		.sum (
			encrypt ? 32'ha708_a81e	//DELTA*14
					: 32'hbe1e_08bb	//DELTA*19
		),
		.outFirst(black14),
		.outSecond(red14)
	);
	
		
// Round 15:
	wire [31:0] red15, black15;
	
	singleTEA tea15 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black14),
		.inSecond(red14),
		.sum (
			encrypt ? 32'h4540_21d7	//DELTA*15
					: 32'h1fe6_8f02	//DELTA*18
		),
		.outFirst(black15),
		.outSecond(red15)
	);
	
	
// Round 16:
	wire [31:0] red16, black16;
	
	singleTEA tea16 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black15),
		.inSecond(red15),
		.sum (
			encrypt ? 32'he377_9b90	//DELTA*16
					: 32'h81af_1549	//DELTA*17
		),
		.outFirst(black16),
		.outSecond(red16)
	);
	
		
// Round 17:
	wire [31:0] red17, black17;
	
	singleTEA tea17 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black16),
		.inSecond(red16),
		.sum (
			encrypt ? 32'h81af_1549	//DELTA*17
					: 32'he377_9b90	//DELTA*16
		),
		.outFirst(black17),
		.outSecond(red17)
	);
	
	
// Round 18:
	wire [31:0] red18, black18;
	
	singleTEA tea18 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black17),
		.inSecond(red17),
		.sum (
			encrypt ? 32'h1fe6_8f02	//DELTA*18
					: 32'h4540_21d7	//DELTA*15
		),
		.outFirst(black18),
		.outSecond(red18)
	);
	
	
// Round 19:
	wire [31:0] red19, black19;
	
	singleTEA tea19 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black18),
		.inSecond(red18),
		.sum (
			encrypt ? 32'hbe1e_08bb	//DELTA*19
					: 32'ha708_a81e	//DELTA*14
		),
		.outFirst(black19),
		.outSecond(red19)
	);
	
	
// Round 20:
	wire [31:0] red20, black20;
	
	singleTEA tea20 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black19),
		.inSecond(red19),
		.sum (
			encrypt ? 32'h5c55_8274	//DELTA*20
					: 32'h08d1_2e65	//DELTA*13
		),
		.outFirst(black20),
		.outSecond(red20)
	);
	
		
// Round 21:
	wire [31:0] red21, black21;
	
	singleTEA tea21 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black20),
		.inSecond(red20),
		.sum (
			encrypt ? 32'hfa8c_fc2d	//DELTA*21
					: 32'h6a99_b4ac	//DELTA*12
		),
		.outFirst(black21),
		.outSecond(red21)
	);
	
	
// Round 22:
	wire [31:0] red22, black22;
	
	singleTEA tea22 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black21),
		.inSecond(red21),
		.sum (
			encrypt ? 32'h98c4_75e6	//DELTA*22
					: 32'hcc62_3af3	//DELTA*11
		),
		.outFirst(black22),
		.outSecond(red22)
	);
	
		
// Round 23:
	wire [31:0] red23, black23;
	
	singleTEA tea23 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black22),
		.inSecond(red22),
		.sum (
			encrypt ? 32'h36fb_ef9f	//DELTA*23
					: 32'h2e2a_c13a	//DELTA*10
		),
		.outFirst(black23),
		.outSecond(red23)
	);
	
	
// Round 24:
	wire [31:0] red24, black24;
	
	singleTEA tea24 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black23),
		.inSecond(red23),
		.sum (
			encrypt ? 32'hd533_6958	//DELTA*24
					: 32'h8ff3_4781	//DELTA*9
		),
		.outFirst(black24),
		.outSecond(red24)
	);
	
		
// Round 25:
	wire [31:0] red25, black25;
	
	singleTEA tea25 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black24),
		.inSecond(red24),
		.sum (
			encrypt ? 32'h736a_e311	//DELTA*25
					: 32'hf1bb_cdc8	//DELTA*8
		),
		.outFirst(black25),
		.outSecond(red25)
	);
	
	
// Round 26:
	wire [31:0] red26, black26;
	
	singleTEA tea26 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black25),
		.inSecond(red25),
		.sum (
			encrypt ? 32'h11a2_5cca	//DELTA*26
					: 32'h5384_540f	//DELTA*7
		),
		.outFirst(black26),
		.outSecond(red26)
	);
	
	
// Round 27:
	wire [31:0] red27, black27;
	
	singleTEA tea27 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black26),
		.inSecond(red26),
		.sum (
			encrypt ? 32'hafd9_d683	//DELTA*27
					: 32'hb54c_da56	//DELTA*6
		),
		.outFirst(black27),
		.outSecond(red27)
	);
	
		
// Round 28:
	wire [31:0] red28, black28;
	
	singleTEA tea28 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black27),
		.inSecond(red27),
		.sum (
			encrypt ? 32'h4e11_503c	//DELTA*28
					: 32'h1715_609d	//DELTA*5
		),
		.outFirst(black28),
		.outSecond(red28)
	);
	
	
// Round 29:
	wire [31:0] red29, black29;
	
	singleTEA tea29 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black28),
		.inSecond(red28),
		.sum (
			encrypt ? 32'hec48_c9f5	//DELTA*29
					: 32'h78dd_e6e4	//DELTA*4
		),
		.outFirst(black29),
		.outSecond(red29)
	);
	
		
// Round 30:
	wire [31:0] red30, black30;
	
	singleTEA tea30 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black29),
		.inSecond(red29),
		.sum (
			encrypt ? 32'h8a80_43ae	//DELTA*30
					: 32'hdaa6_6d2b	//DELTA*3
		),
		.outFirst(black30),
		.outSecond(red30)
	);
	
	
// Round 31:
	wire [31:0] red31, black31;
	
	singleTEA tea31 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black30),
		.inSecond(red30),
		.sum (
			encrypt ? 32'h28b7_bd67	//DELTA*31
					: 32'h3c6e_f372	//DELTA*2
		),
		.outFirst(black31),
		.outSecond(red31)
	);
	
					
/*
 * 32nd round of TEA.
 * Input is from warie fom prevoius round.
 * Output goes on the output of top level module.
 * This is the processed 64 bit block.
 */
	singleTEA tea32 (
		.clk(clk),
		.encrypt(encrypt),
		.key(key),
		.inFirst(black31),
		.inSecond(red31),
		.sum(
			encrypt ? 32'hc6ef_3720	//DELTA*32
					: 32'h9e37_79b9	//DELTA*1
		),
		.outFirst(outBlock64[31:0]),
		.outSecond(outBlock64[63:32])
	);
	
	
endmodule
