/*
 * by SYCY_Proj_3
 *
 * Scheduler for several parallel synchronized TEA decryptors
 *
 *
 */
 
module parallel_tea_scheduler (
	input			clk, ena, rst,
	input	[ 63:0] inBlock64,
	input	[127:0]	key,
			
	output			rdy,			// flag outgoing blocks as relevant output - first 32 are garbage.
	output	[ 63:0]	outBlock64
	
);

/*
 * MP: Pani Kasiu, proszę wstawić Kacprowi -100pkt (słownie: minus sto punktów).
 * KK: (...)
 * MP: Bo zasłużył.
 * KK: (...)
 * MP: On już wie, dlaczego.
 * KK: A, OK. W takim razie już wstawiam.
 * MP: Dziękuję bardzo.
 * KK: Nie ma za co :)
 * MP: Ależ jest, naprawdę :)
 * KK: Ależ nie ma o czym mówić :D
 * MP: Jeszcze raz - dziękuję <3
 * KK: Cała przyjemność po mojej stronie <3
 * MP: 8)
 *
 */

// ============================ Prepare slow clock for distribution:
 	wire 			slow_clk;
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


	
//	reg		[ 7:0] clock_ptr;			// clock pointer - clk signal distribution for parallel TEA instances
	reg		[ 7:0] instance_ptr;		// instance pointer - indicates TEA instance currently returning output
//	wire	[ 7:0] clock_schedule;
//	reg		[63:0] out_reg;
//	wire	[63:0] out_wire;

//	reg clk_div;	// zegar powolny

	
	wire	[63:0] out_w_0;
//	reg		[63:0] out_r_0;
	wire	[63:0] out_w_1;
//	reg		[63:0] out_r_1;
	wire	[63:0] out_w_2;
//	reg		[63:0] out_r_2;
	wire	[63:0] out_w_3;
//	reg		[63:0] out_r_3;
	wire	[63:0] out_w_4;
//	reg		[63:0] out_r_4;
	wire	[63:0] out_w_5;
//	reg		[63:0] out_r_5;
	wire	[63:0] out_w_6;
//	reg		[63:0] out_r_6;
	wire	[63:0] out_w_7;
//	reg		[63:0] out_r_7;
	
	
//	assign clock_schedule = clock_ptr | 8*{clk};
//	assign outBlock64 = out_w_0 & 64*{clock_ptr[0]};
	
	always@(negedge clk or posedge rst) begin
		// this is a 8-bit wide reg with a '1' in only one place
		// this '1' is rotated left by 1 with each clock cycle
		// it points to the TEA block receiving input and supplying output
		if (rst) begin
//			clock_ptr		<= 8'b00001111;
			instance_ptr	<= 8'b00001000;
		end
		else if (ena) begin
//			clock_ptr <= {clock_ptr[6:0], clock_ptr[7]};			// rotate left one bit
			instance_ptr <= {instance_ptr[6:0], instance_ptr[7]};	// rotate left one bit
		end
			
	end
/*	
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			out_r_0		<= 0;
			out_r_1		<= 0;
			out_r_2		<= 0;
			out_r_3		<= 0;
			out_r_4		<= 0;
			out_r_5		<= 0;
			out_r_6		<= 0;
			out_r_7		<= 0;
			
			out_reg		<= 0;
		end
		else if (ena) begin
			out_r_0 <= out_w_0 & {64{clock_ptr[0]}};
			out_r_1 <= out_w_1 & {64{clock_ptr[1]}};
			out_r_2 <= out_w_2 & {64{clock_ptr[2]}};
			out_r_3 <= out_w_3 & {64{clock_ptr[3]}};
			out_r_4 <= out_w_4 & {64{clock_ptr[4]}};
			out_r_5 <= out_w_5 & {64{clock_ptr[5]}};
			out_r_6 <= out_w_6 & {64{clock_ptr[6]}};
			out_r_7 <= out_w_7 & {64{clock_ptr[7]}};
			
			out_reg <= out_r_0 | out_r_1 | out_r_2 | out_r_3 | out_r_4 | out_r_5 | out_r_6 | out_r_7;

		end
	end // always
	*/
//	always@(*) begin
//		out_r_0 = out_w_0 & clock_ptr[0];
//		out_r_1 = out_w_1 & clock_ptr[1];
//		out_r_2 = out_w_2 & clock_ptr[2];
//		out_r_3 = out_w_3 & clock_ptr[3];
//		out_r_4 = out_w_4 & clock_ptr[4];
//		out_r_5 = out_w_5 & clock_ptr[5];
//		out_r_6 = out_w_6 & clock_ptr[6];
//		out_r_7 = out_w_7 & clock_ptr[7];
//	end
	
	assign outBlock64 = (out_w_0 & {64{instance_ptr[0]}}) |
						(out_w_1 & {64{instance_ptr[1]}}) |
						(out_w_2 & {64{instance_ptr[2]}}) |
						(out_w_3 & {64{instance_ptr[3]}}) |
						(out_w_4 & {64{instance_ptr[4]}}) |
						(out_w_5 & {64{instance_ptr[5]}}) |
						(out_w_6 & {64{instance_ptr[6]}}) |
						(out_w_7 & {64{instance_ptr[7]}});

	
//	assign outBlock64 = out_reg;
	
	
	
// Parallel TEA instance 0:	
	full_sync_decryptor full_tea_0 (
		.clk		(clk_split[0]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_0)
	);
	
// Parallel TEA instance 1:
	full_sync_decryptor full_tea_1 (
		.clk		(clk_split[1]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_1)
	);

// Parallel TEA instance 2:
	full_sync_decryptor full_tea_2 (
		.clk		(clk_split[2]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_2)
	);
	
// Parallel TEA instance 3:
	full_sync_decryptor full_tea_3 (
		.clk		(clk_split[3]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_3)
	);
	
// Parallel TEA instance 4:	
	full_sync_decryptor full_tea_4 (
		.clk		(clk_split[4]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_4)
	);
	
// Parallel TEA instance 5:
	full_sync_decryptor full_tea_5 (
		.clk		(clk_split[5]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_5)
	);

// Parallel TEA instance 6:
	full_sync_decryptor full_tea_6 (
		.clk(clk_split[6]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_6)
	);
	
// Parallel TEA instance 7:
	full_sync_decryptor full_tea_7 (
		.clk		(clk_split[7]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_7)
	);


	
	
endmodule
