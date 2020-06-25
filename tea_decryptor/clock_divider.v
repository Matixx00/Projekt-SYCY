module clock_divider(
	input 		 rst,
	input 		 clk,
	input 		 ena,
//	input	 [2:0] div_sel,
	output reg	 div_clk
);
	localparam N = 3;		// 1/8 clk
	
	reg				div_clk_next;
	reg		[N-1:0]	cnt_reg;
	wire	[N-1:0]	cnt_next; 
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			cnt_reg	<= 0;
			div_clk	<= 0;
		end
		else if (ena) begin
			cnt_reg <= cnt_next;
			div_clk <= div_clk_next;
		end
	end
	
	assign cnt_next = cnt_reg + 1;
	
	always@(*) begin
		div_clk_next = cnt_reg[2];
	end
	
endmodule
