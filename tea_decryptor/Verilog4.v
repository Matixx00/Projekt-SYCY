module Ff (
	input reg[127:0] 	key,
	input reg[31:0]		v,
						z,
	output
);

// 48 75 6C 6B │ 20 69 73 20 │ 74 68 61 6C │ 61 6D 69 63
// Hulk is thalamic
force key 0x48756C6B206973207468616C616D6963
force v	// 32 bity z pdf-a w hexach
force z	// 32 bity z pdf-a w hexach
run 
// odczyt

endmodule
