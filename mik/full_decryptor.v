module full_decryptor(
	input			clk, ena, rst,	// standard controlls
//					encrypt,		// should we encrypt?
	input	[ 63:0]	inBlock64,		// a 64 bit block to process
	input	[127:0]	key,			// key for en/decryption
	
	output	[ 63:0]	outBlock64		// processed 64 bit block
);

	localparam DELTA = 32'h9e37_79b9;	// from TEA specs    (sqrt(5)-1) * 2^31

/*
 * First round of TEA.
 * Input for processing is from parent module input inBlock64.
 * Output goes on the wire, to be input into the 2nd round of TEA.
 */
	wire [31:0] wire_1_V1, wire_1_V0;
	
	decryptor_single_round tea_dec_1 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(inBlock64[31: 0]),
		.inV1(inBlock64[63:32]),
		.sum (
//			encrypt ? 32'h9e37_79b9	//DELTA*1
//					: 32'hc6ef_3720	//
					DELTA*32
		),
		.outputV0(wire_1_V0),
		.outputV1(wire_1_V1)
	);

	
// Trying to put a flip-flop between individual TEA modules:	
	reg [63:0] flipper1;	//
	always@(posedge clk) begin
		flipper1 <= {wire_1_V1, wire_1_V0};
	end

	wire [31:0] wire_2_V1_t, wire_2_V0_t;

	assign wire_2_V0_t = flipper1[31: 0];
	assign wire_2_V1_t = flipper1[63:32];
// ---------------------------------------------------------
	
	
/*
 * 2nd round of TEA.
 * Input is from previous round on the previous wire.
 * Output is on new wire for the following round.
 */
	wire [31:0] wire_2_V0, wire_2_V1;
	
	decryptor_single_round tea_dec_2 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_2_V0_t),
		.inV1(wire_2_V1_t),
		.sum (
//			encrypt ? 32'h3c6e_f372	//DELTA*2
//					: 32'h28b7_bd67	//
					DELTA*31
		),
		.outputV0(wire_2_V0),
		.outputV1(wire_2_V1)
	);
	
	reg [63:0] flipper2;
	always@(posedge clk) begin
		flipper2 <= {wire_2_V1, wire_2_V0};
	end

	wire [31:0] wire_3_V0_t, wire_3_V1_t;

	assign wire_3_V0_t = flipper2[31: 0];
	assign wire_3_V1_t = flipper2[63:32];
	
	
// Round 3:
	wire [31:0] wire_3_V1, wire_3_V0;
	
	decryptor_single_round tea_dec_3 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_3_V0_t),
		.inV1(wire_3_V1_t),
		.sum (
//			encrypt ? 32'hdaa6_6d2b	//DELTA*3
//					: 32'h8a80_43ae	//
					DELTA*30
		),
		.outputV0(wire_3_V0),
		.outputV1(wire_3_V1)
	);
	
	reg [63:0] flipper3;
	always@(posedge clk) begin
		flipper3 <= {wire_3_V1, wire_3_V0};
	end

	wire [31:0] wire_4_V0_t, wire_4_V1_t;

	assign wire_4_V0_t = flipper3[31: 0];
	assign wire_4_V1_t = flipper3[63:32];
	
// Round 4:
	wire [31:0] wire_4_V1, wire_4_V0;
	
	decryptor_single_round tea_dec_4 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_4_V0_t),
		.inV1(wire_4_V1_t),
		.sum (
//			encrypt ? 32'h78dd_e6e4	//DELTA*4
//					: 32'hec48_c9f5	//
					DELTA*29
		),
		.outputV0(wire_4_V0),
		.outputV1(wire_4_V1)
	);
	
	reg [63:0] flipper4;
	always@(posedge clk) begin
		flipper4 <= {wire_4_V1, wire_4_V0};
	end

	wire [31:0] wire_5_V0_t, wire_5_V1_t;

	assign wire_5_V0_t = flipper4[31: 0];
	assign wire_5_V1_t = flipper4[63:32];
	
// Round 5:
	wire [31:0] wire_5_V1, wire_5_V0;
	
	decryptor_single_round tea_dec_5 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_5_V0_t),
		.inV1(wire_5_V1_t),
		.sum (
//			encrypt ? 32'h1715_609d	//DELTA*5
//					: 32'h4e11_503c	//
					DELTA*28
		),
		.outputV0(wire_5_V0),
		.outputV1(wire_5_V1)
	);
	
	reg [63:0] flipper5;
	always@(posedge clk) begin
		flipper5 <= {wire_5_V1, wire_5_V0};
	end

	wire [31:0] wire_6_V0_t, wire_6_V1_t;

	assign wire_6_V0_t = flipper5[31: 0];
	assign wire_6_V1_t = flipper5[63:32];
	
// Round 6:
	wire [31:0] wire_6_V1, wire_6_V0;
	
	decryptor_single_round tea_dec_6 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_6_V0_t),
		.inV1(wire_6_V1_t),
		.sum (
//			encrypt ? 32'hb54c_da56	//DELTA*6
//					: 32'hafd9_d683	//
					DELTA*27
		),
		.outputV0(wire_6_V0),
		.outputV1(wire_6_V1)
	);
	
	reg [63:0] flipper6;
	always@(posedge clk) begin
		flipper6 <= {wire_6_V1, wire_6_V0};
	end

	wire [31:0] wire_7_V0_t, wire_7_V1_t;

	assign wire_7_V0_t = flipper6[31: 0];
	assign wire_7_V1_t = flipper6[63:32];
	
// Round 7:
	wire [31:0] wire_7_V1, wire_7_V0;
	
	decryptor_single_round tea_dec_7 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_7_V0_t),
		.inV1(wire_7_V1_t),
		.sum (
//			encrypt ? 32'h5384_540f	//DELTA*7
//					: 32'h11a2_5cca	//
					DELTA*26
		),
		.outputV0(wire_7_V0),
		.outputV1(wire_7_V1)
	);
	
	reg [63:0] flipper7;
	always@(posedge clk) begin
		flipper7 <= {wire_7_V1, wire_7_V0};
	end

	wire [31:0] wire_8_V0_t, wire_8_V1_t;

	assign wire_8_V0_t = flipper7[31: 0];
	assign wire_8_V1_t = flipper7[63:32];
	
// Round 8:
	wire [31:0] wire_8_V1, wire_8_V0;
	
	decryptor_single_round tea_dec_8 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_8_V0_t),
		.inV1(wire_8_V1_t),
		.sum (
//			encrypt ? 32'hf1bb_cdc8	//DELTA*8
//					: 32'h736a_e311	//
					DELTA*25
		),
		.outputV0(wire_8_V0),
		.outputV1(wire_8_V1)
	);
	
	reg [63:0] flipper8;
	always@(posedge clk) begin
		flipper8 <= {wire_8_V1, wire_8_V0};
	end

	wire [31:0] wire_9_V0_t, wire_9_V1_t;

	assign wire_9_V0_t = flipper8[31: 0];
	assign wire_9_V1_t = flipper8[63:32];
	
// Round 9:
	wire [31:0] wire_9_V1, wire_9_V0;
	
	decryptor_single_round tea_dec_9 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_9_V0_t),
		.inV1(wire_9_V1_t),
		.sum (
//			encrypt ? 32'h8ff3_4781	//DELTA*9
//					: 32'hd533_6958	//
					DELTA*24
		),
		.outputV0(wire_9_V0),
		.outputV1(wire_9_V1)
	);
	
	reg [63:0] flipper9;
	always@(posedge clk) begin
		flipper9 <= {wire_9_V1, wire_9_V0};
	end

	wire [31:0] wire_10_V0_t, wire_10_V1_t;

	assign wire_10_V0_t = flipper9[31: 0];
	assign wire_10_V1_t = flipper9[63:32];
	
// Round 10:
	wire [31:0] wire_10_V1, wire_10_V0;
	
	decryptor_single_round tea_dec_10 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_10_V0_t),
		.inV1(wire_10_V1_t),
		.sum (
//			encrypt ? 32'h2e2a_c13a	//DELTA*10
//					: 32'h36fb_ef9f	//
					DELTA*23
		),
		.outputV0(wire_10_V0),
		.outputV1(wire_10_V1)
	);
	
	reg [63:0] flipper10;
	always@(posedge clk) begin
		flipper10 <= {wire_10_V1, wire_10_V0};
	end

	wire [31:0] wire_11_V0_t, wire_11_V1_t;

	assign wire_11_V0_t = flipper10[31: 0];
	assign wire_11_V1_t = flipper10[63:32];
	
// Round 11:
	wire [31:0] wire_11_V1, wire_11_V0;
	
	decryptor_single_round tea_dec_11 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_11_V0_t),
		.inV1(wire_11_V1_t),
		.sum (
//			encrypt ? 32'hcc62_3af3	//DELTA*11
//					: 32'h98c4_75e6	//
					DELTA*22
		),
		.outputV0(wire_11_V0),
		.outputV1(wire_11_V1)
	);
	
	reg [63:0] flipper11;
	always@(posedge clk) begin
		flipper11 <= {wire_11_V1, wire_11_V0};
	end

	wire [31:0] wire_12_V0_t, wire_12_V1_t;

	assign wire_12_V0_t = flipper11[31: 0];
	assign wire_12_V1_t = flipper11[63:32];
	
// Round 12:
	wire [31:0] wire_12_V1, wire_12_V0;
	
	decryptor_single_round tea_dec_12 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_12_V0_t),
		.inV1(wire_12_V1_t),
		.sum (
//			encrypt ? 32'h6a99_b4ac	//DELTA*12
//					: 32'hfa8c_fc2d	//
					DELTA*21
		),
		.outputV0(wire_12_V0),
		.outputV1(wire_12_V1)
	);
	
	reg [63:0] flipper12;
	always@(posedge clk) begin
		flipper12 <= {wire_12_V1, wire_12_V0};
	end

	wire [31:0] wire_13_V0_t, wire_13_V1_t;

	assign wire_13_V0_t = flipper12[31: 0];
	assign wire_13_V1_t = flipper12[63:32];
		
// Round 13:
	wire [31:0] wire_13_V1, wire_13_V0;
	
	decryptor_single_round tea_dec_13 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_13_V0_t),
		.inV1(wire_13_V1_t),
		.sum (
//			encrypt ? 32'h08d1_2e65	//DELTA*13
//					: 32'h5c55_8274	//
					DELTA*20
		),
		.outputV0(wire_13_V0),
		.outputV1(wire_13_V1)
	);
	
	reg [63:0] flipper13;
	always@(posedge clk) begin
		flipper13 <= {wire_13_V1, wire_13_V0};
	end

	wire [31:0] wire_14_V0_t, wire_14_V1_t;

	assign wire_14_V0_t = flipper13[31: 0];
	assign wire_14_V1_t = flipper13[63:32];
	
// Round 14:
	wire [31:0] wire_14_V1, wire_14_V0;
	
	decryptor_single_round tea_dec_14 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_14_V0_t),
		.inV1(wire_14_V1_t),
		.sum (
//			encrypt ? 32'ha708_a81e	//DELTA*14
//					: 32'hbe1e_08bb	//
					DELTA*19
		),
		.outputV0(wire_14_V0),
		.outputV1(wire_14_V1)
	);
	
	reg [63:0] flipper14;
	always@(posedge clk) begin
		flipper14 <= {wire_14_V1, wire_14_V0};
	end

	wire [31:0] wire_15_V0_t, wire_15_V1_t;

	assign wire_15_V0_t = flipper14[31: 0];
	assign wire_15_V1_t = flipper14[63:32];
		
// Round 15:
	wire [31:0] wire_15_V1, wire_15_V0;
	
	decryptor_single_round tea_dec_15 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_15_V0_t),
		.inV1(wire_15_V1_t),
		.sum (
//			encrypt ? 32'h4540_21d7	//DELTA*15
//					: 32'h1fe6_8f02	//
					DELTA*18
		),
		.outputV0(wire_15_V0),
		.outputV1(wire_15_V1)
	);
	
	reg [63:0] flipper15;
	always@(posedge clk) begin
		flipper15 <= {wire_15_V1, wire_15_V0};
	end

	wire [31:0] wire_16_V0_t, wire_16_V1_t;

	assign wire_16_V0_t = flipper15[31: 0];
	assign wire_16_V1_t = flipper15[63:32];
	
// Round 16:
	wire [31:0] wire_16_V1, wire_16_V0;
	
	decryptor_single_round tea_dec_16 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_16_V0_t),
		.inV1(wire_16_V1_t),
		.sum (
//			encrypt ? 32'he377_9b90	//DELTA*16
//					: 32'h81af_1549	//
					DELTA*17
		),
		.outputV0(wire_16_V0),
		.outputV1(wire_16_V1)
	);
	
	reg [63:0] flipper16;
	always@(posedge clk) begin
		flipper16 <= {wire_16_V1, wire_16_V0};
	end

	wire [31:0] wire_17_V0_t, wire_17_V1_t;

	assign wire_17_V0_t = flipper16[31: 0];
	assign wire_17_V1_t = flipper16[63:32];
		
// Round 17:
	wire [31:0] wire_17_V1, wire_17_V0;
	
	decryptor_single_round tea_dec_17 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_17_V0_t),
		.inV1(wire_17_V1_t),
		.sum (
//			encrypt ? 32'h81af_1549	//DELTA*17
//					: 32'he377_9b90	//
					DELTA*16
		),
		.outputV0(wire_17_V0),
		.outputV1(wire_17_V1)
	);
	
	reg [63:0] flipper17;
	always@(posedge clk) begin
		flipper17 <= {wire_17_V1, wire_17_V0};
	end

	wire [31:0] wire_18_V0_t, wire_18_V1_t;

	assign wire_18_V0_t = flipper17[31: 0];
	assign wire_18_V1_t = flipper17[63:32];
	
// Round 18:
	wire [31:0] wire_18_V1, wire_18_V0;
	
	decryptor_single_round tea_dec_18 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_18_V0_t),
		.inV1(wire_18_V1_t),
		.sum (
//			encrypt ? 32'h1fe6_8f02	//DELTA*18
//					: 32'h4540_21d7	//
					DELTA*15
		),
		.outputV0(wire_18_V0),
		.outputV1(wire_18_V1)
	);
	
	reg [63:0] flipper18;
	always@(posedge clk) begin
		flipper18 <= {wire_18_V1, wire_18_V0};
	end

	wire [31:0] wire_19_V0_t, wire_19_V1_t;

	assign wire_19_V0_t = flipper18[31: 0];
	assign wire_19_V1_t = flipper18[63:32];
	
// Round 19:
	wire [31:0] wire_19_V1, wire_19_V0;
	
	decryptor_single_round tea_dec_19 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_19_V0_t),
		.inV1(wire_19_V1_t),
		.sum (
//			encrypt ? 32'hbe1e_08bb	//DELTA*19
//					: 32'ha708_a81e	//
					DELTA*14
		),
		.outputV0(wire_19_V0),
		.outputV1(wire_19_V1)
	);
	
	reg [63:0] flipper19;
	always@(posedge clk) begin
		flipper19 <= {wire_19_V1, wire_19_V0};
	end

	wire [31:0] wire_20_V0_t, wire_20_V1_t;

	assign wire_20_V0_t = flipper19[31: 0];
	assign wire_20_V1_t = flipper19[63:32];
	
// Round 20:
	wire [31:0] wire_20_V1, wire_20_V0;
	
	decryptor_single_round tea_dec_20 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_20_V0_t),
		.inV1(wire_20_V1_t),
		.sum (
//			encrypt ? 32'h5c55_8274	//DELTA*20
//					: 32'h08d1_2e65	//
					DELTA*13
		),
		.outputV0(wire_20_V0),
		.outputV1(wire_20_V1)
	);
	
	reg [63:0] flipper20;
	always@(posedge clk) begin
		flipper20 <= {wire_20_V1, wire_20_V0};
	end

	wire [31:0] wire_21_V0_t, wire_21_V1_t;

	assign wire_21_V0_t = flipper20[31: 0];
	assign wire_21_V1_t = flipper20[63:32];
		
// Round 21:
	wire [31:0] wire_21_V1, wire_21_V0;
	
	decryptor_single_round tea_dec_21 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_21_V0_t),
		.inV1(wire_21_V1_t),
		.sum (
//			encrypt ? 32'hfa8c_fc2d	//DELTA*21
//					: 32'h6a99_b4ac	//
					DELTA*12
		),
		.outputV0(wire_21_V0),
		.outputV1(wire_21_V1)
	);
	
	reg [63:0] flipper21;
	always@(posedge clk) begin
		flipper21 <= {wire_21_V1, wire_21_V0};
	end

	wire [31:0] wire_22_V0_t, wire_22_V1_t;

	assign wire_22_V0_t = flipper21[31: 0];
	assign wire_22_V1_t = flipper21[63:32];
	
// Round 22:
	wire [31:0] wire_22_V1, wire_22_V0;
	
	decryptor_single_round tea_dec_22 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_22_V0_t),
		.inV1(wire_22_V1_t),
		.sum (
//			encrypt ? 32'h98c4_75e6	//DELTA*22
//					: 32'hcc62_3af3	//
					DELTA*11
		),
		.outputV0(wire_22_V0),
		.outputV1(wire_22_V1)
	);
	
	reg [63:0] flipper22;
	always@(posedge clk) begin
		flipper22 <= {wire_22_V1, wire_22_V0};
	end

	wire [31:0] wire_23_V0_t, wire_23_V1_t;

	assign wire_23_V0_t = flipper22[31: 0];
	assign wire_23_V1_t = flipper22[63:32];
		
// Round 23:
	wire [31:0] wire_23_V1, wire_23_V0;
	
	decryptor_single_round tea_dec_23 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_23_V0_t),
		.inV1(wire_23_V1_t),
		.sum (
//			encrypt ? 32'h36fb_ef9f	//DELTA*23
//					: 32'h2e2a_c13a	//
					DELTA*10
		),
		.outputV0(wire_23_V0),
		.outputV1(wire_23_V1)
	);
	
	reg [63:0] flipper23;
	always@(posedge clk) begin
		flipper23 <= {wire_23_V1, wire_23_V0};
	end

	wire [31:0] wire_24_V0_t, wire_24_V1_t;

	assign wire_24_V0_t = flipper23[31: 0];
	assign wire_24_V1_t = flipper23[63:32];
	
// Round 24:
	wire [31:0] wire_24_V1, wire_24_V0;
	
	decryptor_single_round tea_dec_24 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_24_V0_t),
		.inV1(wire_24_V1_t),
		.sum (
//			encrypt ? 32'hd533_6958	//DELTA*24
//					: 32'h8ff3_4781	//
					DELTA*9
		),
		.outputV0(wire_24_V0),
		.outputV1(wire_24_V1)
	);
	
	reg [63:0] flipper24;
	always@(posedge clk) begin
		flipper24 <= {wire_24_V1, wire_24_V0};
	end

	wire [31:0] wire_25_V0_t, wire_25_V1_t;

	assign wire_25_V0_t = flipper24[31: 0];
	assign wire_25_V1_t = flipper24[63:32];
		
// Round 25:
	wire [31:0] wire_25_V1, wire_25_V0;
	
	decryptor_single_round tea_dec_25 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_25_V0_t),
		.inV1(wire_25_V1_t),
		.sum (
//			encrypt ? 32'h736a_e311	//DELTA*25
//					: 32'hf1bb_cdc8	//
					DELTA*8
		),
		.outputV0(wire_25_V0),
		.outputV1(wire_25_V1)
	);
	
	reg [63:0] flipper25;
	always@(posedge clk) begin
		flipper25 <= {wire_25_V1, wire_25_V0};
	end

	wire [31:0] wire_26_V0_t, wire_26_V1_t;

	assign wire_26_V0_t = flipper25[31: 0];
	assign wire_26_V1_t = flipper25[63:32];
	
// Round 26:
	wire [31:0] wire_26_V1, wire_26_V0;
	
	decryptor_single_round tea_dec_26 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_26_V0_t),
		.inV1(wire_26_V1_t),
		.sum (
//			encrypt ? 32'h11a2_5cca	//DELTA*26
//					: 32'h5384_540f	//
					DELTA*7
		),
		.outputV0(wire_26_V0),
		.outputV1(wire_26_V1)
	);
	
	reg [63:0] flipper26;
	always@(posedge clk) begin
		flipper26 <= {wire_26_V1, wire_26_V0};
	end

	wire [31:0] wire_27_V0_t, wire_27_V1_t;

	assign wire_27_V0_t = flipper26[31: 0];
	assign wire_27_V1_t = flipper26[63:32];
	
// Round 27:
	wire [31:0] wire_27_V1, wire_27_V0;
	
	decryptor_single_round tea_dec_27 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_27_V0_t),
		.inV1(wire_27_V1_t),
		.sum (
//			encrypt ? 32'hafd9_d683	//DELTA*27
//					: 32'hb54c_da56	//
					DELTA*6
		),
		.outputV0(wire_27_V0),
		.outputV1(wire_27_V1)
	);
	
	reg [63:0] flipper27;
	always@(posedge clk) begin
		flipper27 <= {wire_27_V1, wire_27_V0};
	end

	wire [31:0] wire_28_V0_t, wire_28_V1_t;

	assign wire_28_V0_t = flipper27[31: 0];
	assign wire_28_V1_t = flipper27[63:32];
		
// Round 28:
	wire [31:0] wire_28_V1, wire_28_V0;
	
	decryptor_single_round tea_dec_28 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_28_V0_t),
		.inV1(wire_28_V1_t),
		.sum (
//			encrypt ? 32'h4e11_503c	//DELTA*28
//					: 32'h1715_609d	//
					DELTA*5
		),
		.outputV0(wire_28_V0),
		.outputV1(wire_28_V1)
	);
	
	reg [63:0] flipper28;
	always@(posedge clk) begin
		flipper28 <= {wire_28_V1, wire_28_V0};
	end

	wire [31:0] wire_29_V0_t, wire_29_V1_t;

	assign wire_29_V0_t = flipper28[31: 0];
	assign wire_29_V1_t = flipper28[63:32];
	
// Round 29:
	wire [31:0] wire_29_V1, wire_29_V0;
	
	decryptor_single_round tea_dec_29 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_29_V0_t),
		.inV1(wire_29_V1_t),
		.sum (
//			encrypt ? 32'hec48_c9f5	//DELTA*29
//					: 32'h78dd_e6e4	//
					DELTA*4
		),
		.outputV0(wire_29_V0),
		.outputV1(wire_29_V1)
	);
	
	reg [63:0] flipper29;
	always@(posedge clk) begin
		flipper29 <= {wire_29_V1, wire_29_V0};
	end

	wire [31:0] wire_30_V0_t, wire_30_V1_t;

	assign wire_30_V0_t = flipper29[31: 0];
	assign wire_30_V1_t = flipper29[63:32];
		
// Round 30:
	wire [31:0] wire_30_V1, wire_30_V0;
	
	decryptor_single_round tea_dec_30 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_30_V0_t),
		.inV1(wire_30_V1_t),
		.sum (
//			encrypt ? 32'h8a80_43ae	//DELTA*30
//					: 32'hdaa6_6d2b	//
					DELTA*3
		),
		.outputV0(wire_30_V0),
		.outputV1(wire_30_V1)
	);
	
	reg [63:0] flipper30;
	always@(posedge clk) begin
		flipper30 <= {wire_30_V1, wire_30_V0};
	end

	wire [31:0] wire_31_V0_t, wire_31_V1_t;

	assign wire_31_V0_t = flipper30[31: 0];
	assign wire_31_V1_t = flipper30[63:32];
	
// Round 31:
	wire [31:0] wire_31_V1, wire_31_V0;
	
	decryptor_single_round tea_dec_31 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_31_V0_t),
		.inV1(wire_31_V1_t),
		.sum (
//			encrypt ? 32'h28b7_bd67	//DELTA*31
//					: 32'h3c6e_f372	//
					DELTA*2
		),
		.outputV0(wire_31_V0),
		.outputV1(wire_31_V1)
	);
	
	reg [63:0] flipper31;
	always@(posedge clk) begin
		flipper31 <= {wire_31_V1, wire_31_V0};
	end

	wire [31:0] wire_32_V0_t, wire_32_V1_t;

	assign wire_32_V0_t = flipper31[31: 0];
	assign wire_32_V1_t = flipper31[63:32];
					
/*
 * 32nd round of TEA.
 * Input is from wire from prevoius round.
 * Output goes on the output of parent module.
 * This is the processed 64 bit block.
 */
	wire [31:0] wire_32_V1, wire_32_V0;
	
	decryptor_single_round tea_dec_32 (
//		.clk(clk),
//		.encrypt(encrypt),
		.key(key),
		.inV0(wire_32_V0_t),
		.inV1(wire_32_V1_t),
		.sum(
//			encrypt ? 32'hc6ef_3720	//DELTA*32
//					: 32'h9e37_79b9	//
					DELTA*1
		),
		.outputV0(wire_32_V0),
		.outputV1(wire_32_V1)
	);
	
	reg [63:0] flipper32;
	always@(posedge clk) begin
		flipper32 <= {wire_32_V1, wire_32_V0};
	end

	assign outBlock64[31: 0] = flipper32[31: 0];
	assign outBlock64[63:32] = flipper32[63:32];
	
endmodule
