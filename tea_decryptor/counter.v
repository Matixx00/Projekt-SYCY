module counter(
	input 		 rst,
	input 		 clk,
	input 		 ena,
	output [7:0] value	
);
	reg  [7:0] cnt_reg;
	wire [7:0] cnt_next; 

	// State register
	always@(posedge clk or posedge rst) begin
		if (rst) 
			cnt_reg <= 0;
		else if (ena)
			cnt_reg <= cnt_next;
	end
	
	// Next state logic
	assign cnt_next = cnt_reg + 1;
						  
	// Output logic
	assign value = cnt_reg;
endmodule
