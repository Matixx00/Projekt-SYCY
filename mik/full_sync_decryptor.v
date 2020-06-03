/*
 * Synchronized decryptor
 *
 */



module full_sync_decryptor(
	input			clk, ena, rst,	// standard controlls
	input	[ 63:0]	inBlock64,		// a 64 bit block to process
	input	[127:0]	key,			// key for en/decryption
	
	output	[ 63:0]	outBlock64		// processed 64 bit block
);

	localparam DELTA = 32'h9e37_79b9;	// from TEA specs    (sqrt(5)-1) * 2^31

	
	

/*
 * First flip-flop.
 * In future perhaps a multiplexer(for auto key searching machine)
 * Recieve input from input wires.
 * Pass on to first round of TEA.
 */	
	reg [63:0] flipper1;	//
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper1 <= 1'b0;
		else if (clk)
			flipper1 <= inBlock64;	// plug input wire into flip-flop
	end
/*
 * First round of TEA.
 * Input for processing is from first flop-flop.
 * Output goes on the wire, to be input into the 2nd flip-flop and then further into 2nd round of TEA.
 */
	wire [31:0] wire_1_V0, wire_1_V1;
	
	decryptor_single_round tea_dec_1 (
		.key(key),
		.inV0(flipper1[63:32]),
		.inV1(flipper1[31:0]),
		.sum(DELTA*32),
		.outputV0(wire_1_V0),
		.outputV1(wire_1_V1)
	);

	
	reg [63:0] flipper2;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper2 <= 1'b0;
		else if (clk)
			flipper2 <= {wire_1_V1, wire_1_V0};	// from above
	end

	
	
/*
 * 2nd round of TEA.
 * Input is from previous flip-flop.
 * Output is on new wire for the following flip-flop and into the following round.
 */
	wire [31:0] wire_2_V0, wire_2_V1;
	
	decryptor_single_round tea_dec_2 (
		.key(key),
		.inV0(flipper2[31: 0]),
		.inV1(flipper2[63:32]),
		.sum(DELTA*31),
		.outputV0(wire_2_V0),
		.outputV1(wire_2_V1)
	);

	reg [63:0] flipper3;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper3 <= 1'b0;
		else if (clk)
			flipper3 <= {wire_2_V1, wire_2_V0};	// from above
	end
	


	
// Round 3:
	wire [31:0] wire_3_V1, wire_3_V0;
	
	decryptor_single_round tea_dec_3 (
		.key(key),
		.inV0(flipper3[31: 0]),
		.inV1(flipper3[63:32]),
		.sum(DELTA*30),
		.outputV0(wire_3_V0),
		.outputV1(wire_3_V1)
	);
	
	reg [63:0] flipper4;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper4 <= 1'b0;
		else if (clk)
			flipper4 <= {wire_3_V1, wire_3_V0};	// from above
	end


	

// Round 4:
	wire [31:0] wire_4_V1, wire_4_V0;
	
	decryptor_single_round tea_dec_4 (
		.key(key),
		.inV0(flipper4[31: 0]),
		.inV1(flipper4[63:32]),
		.sum(DELTA*29),
		.outputV0(wire_4_V0),
		.outputV1(wire_4_V1)
	);
	
	reg [63:0] flipper5;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper5 <= 1'b0;
		else if (clk)
			flipper5 <= {wire_4_V1, wire_4_V0};	// from above
	end

	
	
	
// Round 5:
	wire [31:0] wire_5_V1, wire_5_V0;
	
	decryptor_single_round tea_dec_5 (
		.key(key),
		.inV0(flipper5[31: 0]),
		.inV1(flipper5[63:32]),
		.sum (DELTA*28),
		.outputV0(wire_5_V0),
		.outputV1(wire_5_V1)
	);
	
	reg [63:0] flipper6;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper6 <= 1'b0;
		else if (clk)
			flipper6 <= {wire_5_V1, wire_5_V0};	// from above
	end
	
	
	
// Round 6:
	wire [31:0] wire_6_V1, wire_6_V0;
	
	decryptor_single_round tea_dec_6 (
		.key(key),
		.inV0(flipper6[31: 0]),
		.inV1(flipper6[63:32]),
		.sum (DELTA*27),
		.outputV0(wire_6_V0),
		.outputV1(wire_6_V1)
	);
	
	reg [63:0] flipper7;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper7 <= 1'b0;
		else if (clk)
			flipper7 <= {wire_6_V1, wire_6_V0};	// from above
	end

	
	
// Round 7:
	wire [31:0] wire_7_V1, wire_7_V0;
	
	decryptor_single_round tea_dec_7 (
		.key(key),
		.inV0(flipper7[31: 0]),
		.inV1(flipper7[63:32]),
		.sum (DELTA*26),
		.outputV0(wire_7_V0),
		.outputV1(wire_7_V1)
	);
	
	reg [63:0] flipper8;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper8 <= 1'b0;
		else if (clk)
			flipper8 <= {wire_7_V1, wire_7_V0};	// from above
	end


	
// Round 8:
	wire [31:0] wire_8_V1, wire_8_V0;
	
	decryptor_single_round tea_dec_8 (
		.key(key),
		.inV0(flipper8[31: 0]),
		.inV1(flipper8[63:32]),
		.sum (DELTA*25),
		.outputV0(wire_8_V0),
		.outputV1(wire_8_V1)
	);
	
	reg [63:0] flipper9;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper9 <= 1'b0;
		else if (clk)
			flipper9 <= {wire_8_V1, wire_8_V0};	// from above
	end


	
// Round 9:
	wire [31:0] wire_9_V1, wire_9_V0;
	
	decryptor_single_round tea_dec_9 (
		.key(key),
		.inV0(flipper9[31: 0]),
		.inV1(flipper9[63:32]),
		.sum (DELTA*24),
		.outputV0(wire_9_V0),
		.outputV1(wire_9_V1)
	);
	
	reg [63:0] flipper10;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper10 <= 1'b0;
		else if (clk)
			flipper10 <= {wire_9_V1, wire_9_V0};	// from above
	end


	
// Round 10:
	wire [31:0] wire_10_V1, wire_10_V0;
	
	decryptor_single_round tea_dec_10 (
		.key(key),
		.inV0(flipper10[31: 0]),
		.inV1(flipper10[63:32]),
		.sum (DELTA*23),
		.outputV0(wire_10_V0),
		.outputV1(wire_10_V1)
	);
	
	reg [63:0] flipper11;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper11 <= 1'b0;
		else if (clk)
			flipper11 <= {wire_10_V1, wire_10_V0};	// from above
	end



	
// Round 11:
	wire [31:0] wire_11_V1, wire_11_V0;
	
	decryptor_single_round tea_dec_11 (
		.key(key),
		.inV0(flipper11[31: 0]),
		.inV1(flipper11[63:32]),
		.sum (DELTA*22),
		.outputV0(wire_11_V0),
		.outputV1(wire_11_V1)
	);
	
	reg [63:0] flipper12;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper12 <= 1'b0;
		else if (clk)
			flipper12 <= {wire_11_V1, wire_11_V0};	// from above
	end



	
// Round 12:
	wire [31:0] wire_12_V1, wire_12_V0;
	
	decryptor_single_round tea_dec_12 (
		.key(key),
		.inV0(flipper12[31: 0]),
		.inV1(flipper12[63:32]),
		.sum (DELTA*21),
		.outputV0(wire_12_V0),
		.outputV1(wire_12_V1)
	);
	
	reg [63:0] flipper13;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper13 <= 1'b0;
		else if (clk)
			flipper13 <= {wire_12_V1, wire_12_V0};	// from above
	end



	
// Round 13:
	wire [31:0] wire_13_V1, wire_13_V0;
	
	decryptor_single_round tea_dec_13 (
		.key(key),
		.inV0(flipper13[31: 0]),
		.inV1(flipper13[63:32]),
		.sum (DELTA*20),
		.outputV0(wire_13_V0),
		.outputV1(wire_13_V1)
	);
	
	reg [63:0] flipper14;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper14 <= 1'b0;
		else if (clk)
			flipper14 <= {wire_13_V1, wire_13_V0};	// from above
	end


	
// Round 14:
	wire [31:0] wire_14_V1, wire_14_V0;
	
	decryptor_single_round tea_dec_14 (
		.key(key),
		.inV0(flipper14[31: 0]),
		.inV1(flipper14[63:32]),
		.sum (DELTA*19),
		.outputV0(wire_14_V0),
		.outputV1(wire_14_V1)
	);
	
	reg [63:0] flipper15;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper15 <= 1'b0;
		else if (clk)
			flipper15 <= {wire_14_V1, wire_14_V0};	// from above
	end



	
// Round 15:
	wire [31:0] wire_15_V1, wire_15_V0;
	
	decryptor_single_round tea_dec_15 (
		.key(key),
		.inV0(flipper15[31: 0]),
		.inV1(flipper15[63:32]),
		.sum (DELTA*18),
		.outputV0(wire_15_V0),
		.outputV1(wire_15_V1)
	);
	
	reg [63:0] flipper16;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper16 <= 1'b0;
		else if (clk)
			flipper16 <= {wire_15_V1, wire_15_V0};	// from above
	end
	
	
	
// Round 16:
	wire [31:0] wire_16_V1, wire_16_V0;
	
	decryptor_single_round tea_dec_16 (
		.key(key),
		.inV0(flipper16[31: 0]),
		.inV1(flipper16[63:32]),
		.sum (DELTA*17),
		.outputV0(wire_16_V0),
		.outputV1(wire_16_V1)
	);

	reg [63:0] flipper17;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper17 <= 1'b0;
		else if (clk)
			flipper17 <= {wire_16_V1, wire_16_V0};	// from above
	end


	
		
// Round 17:
	wire [31:0] wire_17_V1, wire_17_V0;
	
	decryptor_single_round tea_dec_17 (
		.key(key),
		.inV0(flipper17[31: 0]),
		.inV1(flipper17[63:32]),
		.sum (DELTA*16),
		.outputV0(wire_17_V0),
		.outputV1(wire_17_V1)
	);
	
	reg [63:0] flipper18;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper18 <= 1'b0;
		else if (clk)
			flipper18 <= {wire_17_V1, wire_17_V0};	// from above
	end


	
// Round 18:
	wire [31:0] wire_18_V1, wire_18_V0;
	
	decryptor_single_round tea_dec_18 (
		.key(key),
		.inV0(flipper18[31: 0]),
		.inV1(flipper18[63:32]),
		.sum (DELTA*15),
		.outputV0(wire_18_V0),
		.outputV1(wire_18_V1)
	);
	
	reg [63:0] flipper19;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper19 <= 1'b0;
		else if (clk)
			flipper19 <= {wire_18_V1, wire_18_V0};	// from above
	end


	
// Round 19:
	wire [31:0] wire_19_V1, wire_19_V0;
	
	decryptor_single_round tea_dec_19 (
		.key(key),
		.inV0(flipper19[31: 0]),
		.inV1(flipper19[63:32]),
		.sum (DELTA*14),
		.outputV0(wire_19_V0),
		.outputV1(wire_19_V1)
	);
	
	reg [63:0] flipper20;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper20 <= 1'b0;
		else if (clk)
			flipper20 <= {wire_19_V1, wire_19_V0};	// from above
	end



	
// Round 20:
	wire [31:0] wire_20_V1, wire_20_V0;
	
	decryptor_single_round tea_dec_20 (
		.key(key),
		.inV0(flipper20[31: 0]),
		.inV1(flipper20[63:32]),
		.sum (DELTA*13),
		.outputV0(wire_20_V0),
		.outputV1(wire_20_V1)
	);
	
	reg [63:0] flipper21;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper21 <= 1'b0;
		else if (clk)
			flipper21 <= {wire_20_V1, wire_20_V0};	// from above
	end



	
// Round 21:
	wire [31:0] wire_21_V1, wire_21_V0;
	
	decryptor_single_round tea_dec_21 (
		.key(key),
		.inV0(flipper21[31: 0]),
		.inV1(flipper21[63:32]),
		.sum (DELTA*12),
		.outputV0(wire_21_V0),
		.outputV1(wire_21_V1)
	);
	
	reg [63:0] flipper22;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper22 <= 1'b0;
		else if (clk)
			flipper22 <= {wire_21_V1, wire_21_V0};	// from above
	end



	
// Round 22:
	wire [31:0] wire_22_V1, wire_22_V0;
	
	decryptor_single_round tea_dec_22 (
		.key(key),
		.inV0(flipper22[31: 0]),
		.inV1(flipper22[63:32]),
		.sum (DELTA*11),
		.outputV0(wire_22_V0),
		.outputV1(wire_22_V1)
	);
	
	reg [63:0] flipper23;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper23 <= 1'b0;
		else if (clk)
			flipper23 <= {wire_22_V1, wire_22_V0};	// from above
	end



	
// Round 23:
	wire [31:0] wire_23_V1, wire_23_V0;
	
	decryptor_single_round tea_dec_23 (
		.key(key),
		.inV0(flipper23[31: 0]),
		.inV1(flipper23[63:32]),
		.sum (DELTA*10),
		.outputV0(wire_23_V0),
		.outputV1(wire_23_V1)
	);
	
	reg [63:0] flipper24;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper24 <= 1'b0;
		else if (clk)
			flipper24 <= {wire_23_V1, wire_23_V0};	// from above
	end



	
// Round 24:
	wire [31:0] wire_24_V1, wire_24_V0;
	
	decryptor_single_round tea_dec_24 (
		.key(key),
		.inV0(flipper24[31: 0]),
		.inV1(flipper24[63:32]),
		.sum (DELTA*9),
		.outputV0(wire_24_V0),
		.outputV1(wire_24_V1)
	);
	
	reg [63:0] flipper25;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper25 <= 1'b0;
		else if (clk)
			flipper25 <= {wire_24_V1, wire_24_V0};	// from above
	end



	
// Round 25:
	wire [31:0] wire_25_V1, wire_25_V0;
	
	decryptor_single_round tea_dec_25 (
		.key(key),
		.inV0(flipper25[31: 0]),
		.inV1(flipper25[63:32]),
		.sum (DELTA*8),
		.outputV0(wire_25_V0),
		.outputV1(wire_25_V1)
	);
	
	reg [63:0] flipper26;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper26 <= 1'b0;
		else if (clk)
			flipper26 <= {wire_25_V1, wire_25_V0};	// from above
	end



	
// Round 26:
	wire [31:0] wire_26_V1, wire_26_V0;
	
	decryptor_single_round tea_dec_26 (
		.key(key),
		.inV0(flipper26[31: 0]),
		.inV1(flipper26[63:32]),
		.sum (DELTA*7),
		.outputV0(wire_26_V0),
		.outputV1(wire_26_V1)
	);
	
	reg [63:0] flipper27;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper27 <= 1'b0;
		else if (clk)
			flipper27 <= {wire_26_V1, wire_26_V0};	// from above
	end



	
// Round 27:
	wire [31:0] wire_27_V1, wire_27_V0;
	
	decryptor_single_round tea_dec_27 (
		.key(key),
		.inV0(flipper27[31: 0]),
		.inV1(flipper27[63:32]),
		.sum (DELTA*6),
		.outputV0(wire_27_V0),
		.outputV1(wire_27_V1)
	);
	
	reg [63:0] flipper28;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper28 <= 1'b0;
		else if (clk)
			flipper28 <= {wire_27_V1, wire_27_V0};	// from above
	end



	
// Round 28:
	wire [31:0] wire_28_V1, wire_28_V0;
	
	decryptor_single_round tea_dec_28 (
		.key(key),
		.inV0(flipper28[31: 0]),
		.inV1(flipper28[63:32]),
		.sum (DELTA*5),
		.outputV0(wire_28_V0),
		.outputV1(wire_28_V1)
	);
	
	reg [63:0] flipper29;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper29 <= 1'b0;
		else if (clk)
			flipper29 <= {wire_28_V1, wire_28_V0};	// from above
	end



	
// Round 29:
	wire [31:0] wire_29_V1, wire_29_V0;
	
	decryptor_single_round tea_dec_29 (
		.key(key),
		.inV0(flipper29[31: 0]),
		.inV1(flipper29[63:32]),
		.sum (DELTA*4),
		.outputV0(wire_29_V0),
		.outputV1(wire_29_V1)
	);
	
	reg [63:0] flipper30;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper30 <= 1'b0;
		else if (clk)
			flipper30 <= {wire_29_V1, wire_29_V0};	// from above
	end



	
// Round 30:
	wire [31:0] wire_30_V1, wire_30_V0;
	
	decryptor_single_round tea_dec_30 (
		.key(key),
		.inV0(flipper30[31: 0]),
		.inV1(flipper30[63:32]),
		.sum (DELTA*3),
		.outputV0(wire_30_V0),
		.outputV1(wire_30_V1)
	);
	
	reg [63:0] flipper31;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper31 <= 1'b0;
		else if (clk)
			flipper31 <= {wire_30_V1, wire_30_V0};	// from above
	end



	
// Round 31:
	wire [31:0] wire_31_V1, wire_31_V0;
	
	decryptor_single_round tea_dec_31 (
		.key(key),
		.inV0(flipper31[31: 0]),
		.inV1(flipper31[63:32]),
		.sum (DELTA*2),
		.outputV0(wire_31_V0),
		.outputV1(wire_31_V1)
	);
	
	reg [63:0] flipper32;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipper32 <= 1'b0;
		else if (clk)
			flipper32 <= {wire_31_V1, wire_31_V0};	// from above
	end



	
/*
 * 32nd round of TEA.
 * Input is from flip-flop from previous round.
 * Output goes on the last flip-flop and onto the output of parent module.
 * This is the processed 64 bit block.
 */
	wire [31:0] wire_32_V1, wire_32_V0;

	decryptor_single_round tea_dec_32 (
		.key(key),
		.inV0(flipper32[31: 0]),
		.inV1(flipper32[63:32]),
		.sum(DELTA*1),
		.outputV0(wire_32_V0),
		.outputV1(wire_32_V1)
	);
	
	reg [63:0] flipperLast;
	always@(posedge clk, posedge rst) begin
		if (rst)
			flipperLast <= 1'b0;
		else if (clk)
			flipperLast <= {wire_32_V0, wire_32_V1};	// from above
	end

	assign outBlock64 = flipperLast;

endmodule
