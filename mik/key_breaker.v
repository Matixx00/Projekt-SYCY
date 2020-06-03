module key_breaker (
	input clk,
	input ena,
	input rst,
	
	// Encrypted header
	input[63:0] header,
	
	// Key that decrypts the header 
	output[127:0] proper_key
);

	reg [127:0] key_reg, key_next;
	always@(posedge clk or posedge rst) begin
		if (rst)
			flipper1 <= 1'b0;
		else if (ena)
			flipper1 <= inBlock64;	// plug input wire into flip-flop
	end

	full_sync_decryptor decryptor (
		.clk(clk),
		.ena(ena),
		.rst(rst),
		.inBlock64(header),
		.key()
	);

endmodule
