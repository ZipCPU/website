////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	dblshift
//
// Project:	Formal verification quizes
//
// Purpose:	This is quiz #11
//
//	Goal: To determine what it will take to get this assertion to pass
//		formal verification.  (It doesn't at present)
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
module	dblshift(i_clk, i_ce, i_bit, o_bit);
	input	wire	i_clk, i_ce, i_bit;
	output	wire	o_bit;

	reg	[15:0]	sa, sb;
	initial	sa = 0;
	initial	sb = 0;

	always @(posedge i_clk)
	if (i_ce)
	begin
		sa <= { sa[14:0], i_bit };
		sb <= { i_bit, sb[15:1] };
	end

	assign	o_bit = sa[15] ^ sb[0];

	always @(*)
		assert(o_bit == 0);
endmodule
