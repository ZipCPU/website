`default_nettype none
//
module	slowmpy_ugly(i_clk, i_stb, i_a, i_b, o_busy, o_result);
	parameter	IW=32;
	input	wire			i_clk, i_stb;
	input	wire	[IW-1:0]	i_a, i_b;
	output	reg			o_busy;
	output	reg	[IW*2-1:0]	o_result;

	reg	[4:0]		count;
	reg	[IW-1:0]	p_a, p_b;

	initial	o_busy = 0;
	always @(posedge i_clk)
	if (!o_busy)
	begin
		count <= 0;
		o_result <= 0;
		p_a <= i_a;
		p_b <= i_b;
		o_busy <= i_stb;
	end else begin
		if (p_b[count])
			o_result <= o_result + ({{(IW){1'b0}}, p_a } << count);
		count <= count + 1;
		o_busy <= (count < 31);
	end
endmodule
