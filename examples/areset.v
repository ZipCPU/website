////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	areset.v
//
// Project:	Formal methods example
//
// Purpose:	This file contains an example asynchronous reset synchronizer.
//		It makes a useful design to formally verify, and so it is
//	provided here as an example of such a design.
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
module areset(i_clk, i_areset_n, o_reset);
	input	wire	i_clk,
			// i_areset_n is an asynchronous, negative logic
			// incoming reset signal
			i_areset_n;
			// o_reset is a synchronous, positive logic, output
			// reset signal.
	output	reg	o_reset;

	// We'll use a 2-clock FIFO to synchronize the release of o_reset
	reg	[1:0]	sync_fifo;

	initial	sync_fifo = 2'h3;
	initial	o_reset = 1'b1;
	always @(posedge i_clk or negedge i_areset_n)
	if (!i_areset_n)
		{ o_reset, sync_fifo } <= 3'h7;
	else
		{ o_reset, sync_fifo } <= { sync_fifo, 1'b0 };

`ifdef	FORMAL
	////////////////////////////////////////////////////
	//
	// Our "contract"
	//
	////////////////////////////////////////////////////
	//

	// Always start in reset
	initial	assume(!i_areset_n);

	always @(*)
	if (!i_areset_n)
		assert((o_reset)&&(sync_fifo == 2'b11));

	// Make sure we can come out of our reset state
	always @(*)
		cover(!o_reset);

	// Only ever synchronously release from reset.
	//
	// Hence, if this isn't the positive edge of a clock
	// then we cannot release the reset.
	//
	always @($global_clock)
	if ($fell(o_reset))
		assert($rose(i_clk));

	// Make sure we can come out of our reset state
	always @(*)
		cover(!o_reset);

	////////////////////////////////////////////////////
	//
	// Extras for passing induction
	//
	////////////////////////////////////////////////////
	// Make sure we don't get into any illegal states during induction
	always @(*)
	if (!o_reset)
		assert(sync_fifo == 2'b00);
	always @(*)
		assert(sync_fifo != 2'b01);
	always @(*)
	if (sync_fifo[1])
		assert(o_reset);

	always @(*)
	if (!i_areset_n)
		assert(sync_fifo == 2'b11);
endmodule
