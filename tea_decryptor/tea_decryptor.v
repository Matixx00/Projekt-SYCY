module tea_decryptor (
	input  rst,
	input  clk,
	input  ena,
	output stream	
);
	
	reg  [7:0] lfsr_reg;
	wire [7:0] lfsr_next; 
	wire 		  feedback;

	// State register
	always@(posedge clk or posedge rst) begin
		if (rst) 
			lfsr_reg <= 8'b10000000;
		else if (ena)
			lfsr_reg <= lfsr_next;
	end
	
	// Maximum length feedback polynomial X8+X6+X5+X4+1, 
	assign feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[3] ^ lfsr_reg[0];
	assign lfsr_next = {lfsr_reg[6:0], feedback};
						  
	assign stream = lfsr_reg[7];

endmodule
