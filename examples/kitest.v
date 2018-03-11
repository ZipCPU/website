////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	kitest.v
//
// Project:	Formal methods example
//
// Purpose:	This file contains an example piece of Verilog code that I find
//		very useful for understanding how the formal induction engine
//	works.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2018, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
module	kitest(i_clk, i_reset, i_ce, i_in, o_bit);
	parameter		LN=16;
	//
	input	wire		i_clk, i_reset, i_ce, i_in;
	output	wire		o_bit;

	reg	[(LN-1):0]	sa, sb;

	initial	sa = 0;
	initial	sb = 0;
	always @(posedge i_clk)
	if (i_reset)
	begin
		sa <= 0;
		sb <= 0;
	end else if (i_ce)
	begin
		sa <= { sa[(LN-2):0], i_in };
		sb <= { sb[(LN-2):0], i_in };
	end

	assign	o_bit = sa[LN-1] ^ sb[LN-1];

`ifdef	FORMAL
	assert property(!o_bit);

	localparam [2:0]	FORMAL_TEST = 3'b001;

	generate if (FORMAL_TEST == 3'b000)
	begin
		// Requires 16 steps

		always @(*)
			assume(i_ce);

	end else if (FORMAL_TEST == 3'b001)
	begin
		// No extra logic

		// Never passes

	end else if (FORMAL_TEST == 3'b010)
	begin
		// Requires 1 step.  Trivially proved

		assert property(sa == sb);

	end else if (FORMAL_TEST == 3'b011)
	begin
		// Requires 31 steps

		always @(posedge i_clk)
		if (!$past(i_ce))
			assume(i_ce);

	end else if (FORMAL_TEST == 3'b100)
	begin
		// Requires 46 steps

		always @(posedge i_clk)
		if ((!$past(i_ce))&&(!$past(i_ce,2)))
			assume(i_ce);

	// else
	//	No formal logic
	end endgenerate
`endif
endmodule
