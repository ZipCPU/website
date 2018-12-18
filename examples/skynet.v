////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	skynet.v
//
// Project:	Formal methods example
//
// Purpose:	This file consists of a counter-example to the theory that
//		assertions may be replaced by assumptions when aggregating
//	modules together.
//
////////////////////////////////////////////////////////////////////////////////
//
// Written and distributed by Gisselquist Technology, LLC, based upon an
// initial design by Clifford Wolf of Symbiotic EDA.
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
module	skynet(i_clk, i_input, o_kill_everyone);
	input	wire		i_clk;
	input	wire	[31:0]	i_input;
	output	reg		o_kill_everyone;

	always @(*)
		o_kill_everyone <= (i_input == 32'hdeadbeef);

`ifdef	FORMAL
`ifdef	SUBMODULE
`define	ASSUME	assume
`define	ASSERT	assert
`else
`define	ASSUME	assert
`define	ASSERT	assume
`endif

	always @(*)
		`ASSUME(i_input != 32'hdeadbeef);

	always @(*)
		`ASSERT(!o_kill_everyone);
`endif
endmodule

module cyberdyne_systems(i_clk, i_input, o_kill_everyone);
	input	wire		i_clk;
	input	wire	[31:0]	i_input;
	output	wire		o_kill_everyone;

	skynet determine_fate_of_humanity(i_clk, i_input, o_kill_everyone);
endmodule
