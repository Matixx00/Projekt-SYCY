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

	
	reg		[ 9:0] clock_ptr;			// clock pointer - clk signal distribution for parallel TEA instances
	reg		[ 9:0] instance_ptr;		// instance pointer - indicates TEA instance currently returning output

	
	wire	[63:0] out_w_0;
	wire	[63:0] out_w_1;
	wire	[63:0] out_w_2;
	wire	[63:0] out_w_3;
	wire	[63:0] out_w_4;
	wire	[63:0] out_w_5;
	wire	[63:0] out_w_6;
	wire	[63:0] out_w_7;
	wire	[63:0] out_w_8;
	wire	[63:0] out_w_9;
	
	
	
	always@(negedge clk or posedge rst) begin
		// this is a 10-bit wide reg with a '1' in only one place
		// this '1' is rotated left by 1 with each clock cycle
		// it points to the TEA block receiving input and supplying output
		if (rst) begin
			clock_ptr		<= 10'b00_0001_1111;	// slow clock
			instance_ptr	<= 10'b00_0000_1000;	// active instance
		end
		else if (ena) begin
			clock_ptr <= {clock_ptr[8:0], clock_ptr[9]};			// rotate left one bit
			instance_ptr <= {instance_ptr[8:0], instance_ptr[9]};	// rotate left one bit
		end
			
	end
	
	assign outBlock64 = (out_w_0 & {64{instance_ptr[0]}}) |
						(out_w_1 & {64{instance_ptr[1]}}) |
						(out_w_2 & {64{instance_ptr[2]}}) |
						(out_w_3 & {64{instance_ptr[3]}}) |
						(out_w_4 & {64{instance_ptr[4]}}) |
						(out_w_5 & {64{instance_ptr[5]}}) |
						(out_w_6 & {64{instance_ptr[6]}}) |
						(out_w_7 & {64{instance_ptr[7]}}) |
						(out_w_8 & {64{instance_ptr[8]}}) |
						(out_w_9 & {64{instance_ptr[9]}});

	
	
	
	
// Parallel TEA instance 0:	
//	full_sync_decryptor full_tea_0 (
	faster_sync_decryptor full_tea_0 (
		.clk		(clock_ptr[0]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_0)
	);
	
// Parallel TEA instance 1:
//	full_sync_decryptor full_tea_1 (
	faster_sync_decryptor full_tea_1 (
		.clk		(clock_ptr[1]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_1)
	);

// Parallel TEA instance 2:
//	full_sync_decryptor full_tea_2 (
	faster_sync_decryptor full_tea_2 (
		.clk		(clock_ptr[2]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_2)
	);
	
// Parallel TEA instance 3:
//	full_sync_decryptor full_tea_3 (
	faster_sync_decryptor full_tea_3 (
		.clk		(clock_ptr[3]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_3)
	);
	
// Parallel TEA instance 4:	
//	full_sync_decryptor full_tea_4 (
	faster_sync_decryptor full_tea_4 (
		.clk		(clock_ptr[4]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_4)
	);
	
// Parallel TEA instance 5:
//	full_sync_decryptor full_tea_5 (
	faster_sync_decryptor full_tea_5 (
		.clk		(clock_ptr[5]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_5)
	);

// Parallel TEA instance 6:
//	full_sync_decryptor full_tea_6 (
	faster_sync_decryptor full_tea_6 (
		.clk		(clock_ptr[6]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_6)
	);
	
// Parallel TEA instance 7:
//	full_sync_decryptor full_tea_7 (
	faster_sync_decryptor full_tea_7 (
		.clk		(clock_ptr[7]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_7)
	);

// Parallel TEA instance 8:
//	full_sync_decryptor full_tea_8 (
	faster_sync_decryptor full_tea_8 (
		.clk		(clock_ptr[8]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_8)
	);
	
// Parallel TEA instance 9:
//	full_sync_decryptor full_tea_9 (
	faster_sync_decryptor full_tea_9 (
		.clk		(clock_ptr[9]),
		.ena		(ena),
		.rst		(rst),
		.inBlock64	(inBlock64),
		.key		(key),
		.outBlock64	(out_w_9)
	);


	
	
endmodule
