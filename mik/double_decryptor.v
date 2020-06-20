module double_decryptor (
	input			clk, ena, rst,
	input	[ 63:0] inBlock64,
	input	[127:0]	key,
			
	output			rdy,			// flag outgoing blocks as relevant output - first 32 are garbage.
	output	[ 63:0]	outBlock64
	
);

	reg instance_ptr;
	reg [63:0] out_reg;
	wire [63:0] out_w_0, out_w_1;
	
	
	always@(posedge clk, posedge rst) begin
		if (rst)
			instance_ptr <= 0;
		else if (ena) begin
			instance_ptr <= ~instance_ptr;
			out_reg <= (out_w_0 & 64*{~instance_ptr}) | (out_w_1 & 64*{instance_ptr});
		end
	end


// Parallel TEA instance 0:	
	full_sync_decryptor full_tea_0 (
		.clk(clk & instance_ptr),
		.ena(ena),
		.rst(rst),
		.inBlock64(inBlock64),
		.key(key),
		.outBlock64(out_w_0)
	);
	
// Parallel TEA instance 1:
	full_sync_decryptor full_tea_1 (
		.clk(clk & instance_ptr),
		.ena(ena),
		.rst(rst),
		.inBlock64(inBlock64),
		.key(key),
		.outBlock64(out_w_1)
	);

	
	assign outBlock64 = out_reg;
	
	
endmodule
