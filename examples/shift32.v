`default_nettype none

module shift32(i_shift, i_value, o_result);
	input	wire	[4:0]	i_shift;
	input	wire	[31:0]	i_value;
	output	reg	[63:0]	o_result;

	always @(*)
		o_result = ({{(32){1'b0}}, i_value } << i_shift);
endmodule
