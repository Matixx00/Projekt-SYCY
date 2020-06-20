/*
 * by SYCY_Proj_3
 *
 * Borrowed from SYCY lab1
 * by PT
 *
 *
 */

module clock_divider(
	input 		 rst,
	input 		 clk,
	input 		 ena,
	output reg	 div_clk
);
	localparam N = 27;
	reg  [N-1:0] cnt_reg;
	wire [N-1:0] cnt_next; 

	always@(posedge clk or posedge rst) begin
		if (rst) 
			cnt_reg <= 0;
		else if (ena)
			cnt_reg <= cnt_next;
	end

	assign cnt_next = cnt_reg + 1;
	
	reg div_clk_next;
	
	always@(posedge clk or posedge rst) begin
		if (rst) 
			div_clk <= 0;
		else if (ena)
			div_clk <= div_clk_next;
	end
						  
	always@(*)
			div_clk_next = cnt_reg[7]; // div_clk = clk/2

	endmodule

