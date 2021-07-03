module mux32(i_bit, i_val, o_r);
	input	wire	[4:0]	i_bit;
	input	wire	[31:0]	i_val;
	output	reg		o_r;

	always @(*)
		o_r = i_val[i_bit];
endmodule
