/*
 * by SYCY_Proj_3
 *
 * First half of TEA decryptor round
 *
 */
 
module decryptor_half_round_1 (
	input	[63:0]	key,
	input	[ 31:0]	inV0,
					inV1,
					sum,	// suppplied from instantiating module - suitable for encryption or decryption
					
	output	[ 31:0]	outputV0,	// least signifficant bits
					outputV1	// most signifficant bits
);

	wire [31:0]	F1_out;
				//F2_out,
				//outWireV1;
	
	
	functionF F1 (
		.inKeyL		(key[ 31:0]),	// k[2]
		.inKeyR		(key[63:32]),	// k[3]
		.sum		(sum),
		.chunk32	(inV0),
		.out32		(F1_out)
	);
/*
	assign outWireV1 = inV1 - F1_out;
	

	functionF F2 (
		.inKeyL	(key[31: 0]),	// k[0]
		.inKeyR	(key[63:32]),	// k[1]
		.sum	(sum),
		.chunk32(outWireV1),
		.out32	(F2_out)
	);
*/
	
//	assign outputV0 = inV0 - F2_out;
	assign outputV0 = inV0;
//	assign outputV1 = outWireV1;
	assign outputV1 = inV1 - F1_out;
	
	
	
endmodule
