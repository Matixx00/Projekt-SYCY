/*
 * by SYCY_Proj_3
 *
 * Scheduler for several parallel synchronized TEA decryptors
 *
 *
 */
 
module parallel_tea_scheduler (
	input			clk, ena, rst,
	input	[ 63:0] in_word64,
	input	[127:0]	key,
			
	output			rdy,			// flag outgoing blocks as relevant output - first 32 are garbage.
	output	[ 63:0]	out_word64
	
);
	reg		[	7:0]		clock_ptr;			// clock pointer
	reg		[512:0]	output_collector;	// 8 64-bit-wide output lanes

	reg [63:0] a_reg;
//	wire [63:0] a_next;
//	reg [512:0] temp_reg;
	
	
	
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			clock_ptr <= 1;
			a_reg <= 0;
		end
		else if (ena) begin
		// this is a 8-bit wide reg with a '1' in only one place
		// this '1' is rotated left by 1 with each clock cycle
		// it points to the TEA block receiving input and supplying output
			clock_ptr <= {clock_ptr[6:0], clock_ptr[7]};		// rotate left one bit
			
		end
	end
	
	
//	always@(*) begin
//			a_reg <= {out_w_0 | out_w_1 | out_w_2 | out_w_3 | out_w_4 | out_w_5 | out_w_6 | out_w_7};
//			out_r_0 <= out_w_0 & clock_ptr[0];
//	end
	
// Parallel TEA instance 0:	
	wire [63:0] out_w_0;
	reg [63:0] out_r_0;
	full_sync_decryptor full_tea_0 (
		.clk(clk & clock_ptr[0]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_0),
	);
	always@(*) begin
		out_r_0 = out_w_0 & clock_ptr[0];
	end
	
// Parallel TEA instance 1:
	wire [63:0] out_w_1;
	reg [63:0] out_r_1;
	full_sync_decryptor full_tea_1 (
		.clk(clk & clock_ptr[1]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_1),
	);
	always@(*) begin
		out_r_1 = out_w_1 & clock_ptr[1];
	end

// Parallel TEA instance 2:
	wire [63:0] out_w_2;
	reg [63:0] out_r_2;
	full_sync_decryptor full_tea_2 (
		.clk(clk & clock_ptr[2]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_2),
	);
	always@(*) begin
		out_r_2 = out_w_2 & clock_ptr[2];
	end
	
// Parallel TEA instance 3:
	wire [63:0] out_w_3;
	reg [63:0] out_r_3;
	full_sync_decryptor full_tea_3 (
		.clk(clk & clock_ptr[3]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_3),
	);
	always@(*) begin
		out_r_3 = out_w_3 & clock_ptr[3];
	end
	
// Parallel TEA instance 4:	
	wire [63:0] out_w_4;
	reg [63:0] out_r_4;
	full_sync_decryptor full_tea_4 (
		.clk(clk & clock_ptr[4]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_4),
	);
	always@(*) begin
		out_r_4 = out_w_4 & clock_ptr[4];
	end
	
// Parallel TEA instance 5:
	wire [63:0] out_w_5;
	reg [63:0] out_r_5;
	full_sync_decryptor full_tea_5 (
		.clk(clk & clock_ptr[5]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_5),
	);
	always@(*) begin
		out_r_5 = out_w_5 & clock_ptr[5];
	end

// Parallel TEA instance 6:
	wire [63:0] out_w_6;
	reg [63:0] out_r_6;
	full_sync_decryptor full_tea_6 (
		.clk(clk & clock_ptr[6]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_6),
	);
	always@(*) begin
		out_r_6 = out_w_6 & clock_ptr[6];
	end
	
// Parallel TEA instance 7:
	wire [63:0] out_w_7;
	reg [63:0] out_r_7;
	full_sync_decryptor full_tea_7 (
		.clk(clk & clock_ptr[7]),
		.ena(ena),
		.rst(rst),
		.inBlock64(in_word64),
		.key(key),
		.outBlock64(out_w_7),
	);
	always@(*) begin
		out_r_7 = out_w_7 & clock_ptr[7];
	end


	assign out_word64 = out_r_0 | out_r_1 | out_r_2 | out_r_3 | out_r_4 | out_r_5 | out_r_6 | out_r_7;
	
	
endmodule
