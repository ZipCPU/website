////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	contradiction.v
//
// Project:	Formal methods example
//
// Purpose:	Illustrates a bug that might easily get missed.  Consider this
//		a formal methods proof that n=n+1.
//
////////////////////////////////////////////////////////////////////////////////
//
// Written and distributed by Gisselquist Technology, LLC, based upon an
// bug I came across in my own work.
//
// This program is hereby given to the public domain.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype none
//
module contradiction(i_clk, i_reset, o_rollover);
	input	wire		i_clk;
	input	wire		i_reset;
	output	reg		o_rollover;

	reg	[15:0]	counter;

	always @(posedge i_clk)
	if (i_reset)
		counter <= 0;
	else
		counter <= counter + 1;

	always @(*)
		o_rollover = counter[15];

`ifdef	FORMAL
	reg	f_past_valid = 0;
	always @(posedge i_clk)
		f_past_valid <= 1;

	always @(*)
	if (f_past_valid)
		assume(i_reset);

	always @(posedge i_clk)
	if (f_past_valid && !i_reset)
		assert(counter == counter + 1);
`endif
endmodule
