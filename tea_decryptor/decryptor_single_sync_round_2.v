module decryptor_single_sync_round_2 (
	input			clk, rst,
	input	[127:0]	key,
	input	[ 31:0]	inV0,
					inV1,
					sum,	// suppplied from instantiating module - suitable for encryption or decryption
					
	output	[ 31:0]	outputV0,	// least signifficant bits
					outputV1	// most signifficant bits
);

	wire	[31:0]	F1_out,
					F2_out;
//					outWireV1;
					
	reg		[63:0]	intermediate_reg;
	
	
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			intermediate_reg <= 64'b0;
//			F2_in_reg <= 32'b0;
		end else begin
//			F1_in_reg <= inV0;
//			F2_in_reg <= F1_out - inV1;
//			F2_in_reg <= inV1 - F1_out;
			intermediate_reg <= {inV1 - F1_out, inV0};
		end
	end
	
	
	
	
	functionF F1 (
		.inKeyL	(key[ 95:64]),	// k[2]
		.inKeyR	(key[127:96]),	// k[3]
		.sum	(sum),
//		.chunk32(F1_in_reg),
		.chunk32(inV0),
		.out32	(F1_out)
	);

//	assign outWireV1 = inV1 - F1_out;
	

	functionF F2 (
		.inKeyL	(key[31: 0]),	// k[0]
		.inKeyR	(key[63:32]),	// k[1]
		.sum	(sum),
		.chunk32(intermediate_reg[63:32]),
		.out32	(F2_out)
	);

	
	assign outputV0 = intermediate_reg[31: 0] - F2_out;
	assign outputV1 = intermediate_reg[63:32];
	
	
	
endmodule
