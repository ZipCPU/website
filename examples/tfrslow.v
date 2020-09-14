////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	tfrslow.v
// {{{
// Project:	Formal methods example
//
// Purpose:	Illustrates a slow method of moving data across clock domains,
//		together with a formal proof of the same.  This is the "slower"
//	version of two methods, the second one given in tfrvalue.v.  This one
//	is slower because it requires a round trip of both the request, the
//	acknowledgement, the clearing of the request, and then finally the
//	clearing of the acknowledgment.
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
`default_nettype	none
// }}}
module tfrslow #(
		parameter	W = 32
	) (
		// {{{
		input	wire		i_a_clk,
		input	wire		i_a_reset_n,
		input	wire		i_a_valid,
		output	wire		o_a_ready,
		input	wire	[W-1:0]	i_a_data,
		//
		input	wire		i_b_clk,
		input	wire		i_b_reset_n,
		output	reg		o_b_valid,
		input	wire		i_b_ready,
		output	reg	[W-1:0]	o_b_data
		// }}}
	);

	// Register declarations
	// {{{
	localparam	NFF = 2;
	reg			a_req, a_ack;
	reg	[W-1:0]		a_data;
	reg	[NFF-2:0]	a_pipe;

	reg			b_req, b_ack, b_stb;
	reg	[NFF-2:0]	b_pipe;
	// }}}

	// A-CLK: Launch data and request
	// {{{
	initial	a_req = 0;
	always @(posedge i_a_clk, negedge i_a_reset_n)
	if (!i_a_reset_n)
		a_req <= 1'b0;
	else if (i_a_valid && !a_req && !a_ack)
		a_req <= 1;
	else if (a_ack)
		a_req <= 0;

	always @(posedge i_a_clk)
	if (i_a_valid && o_a_ready)
		a_data <= i_a_data;

	assign	o_a_ready = !a_req && !a_ack;
	// }}}

	// B-CLK: Request to B
	// {{{
	initial	{ b_ack, b_req, b_pipe } = 0;
	always @(posedge i_b_clk, negedge i_b_reset_n)
	if (!i_b_reset_n)
		{ b_ack, b_req, b_pipe } <= 0;
	else begin
		{ b_ack, b_req, b_pipe } <= { b_req, b_pipe, a_req };
		if (!b_ack && b_req && o_b_valid && !i_b_ready)
			b_ack <= 1'b0;
	end
	// }}}

	// A-CLK: Return ACK
	// {{{
	always @(posedge i_a_clk, negedge i_a_reset_n)
	if (!i_a_reset_n)
		{ a_ack, a_pipe } <= 1'b0;
	else
		{ a_ack, a_pipe } <= { a_pipe, b_ack };
	// }}}

	// B-CLK: Outgoing strobe and data
	// {{{
	always @(*)
		b_stb = !b_ack && b_req && (!o_b_valid || i_b_ready);

	initial	o_b_data = 0;
	always @(posedge i_b_clk)
	if (b_stb)
		o_b_data <= a_data;

	initial	o_b_valid = 0;
	always @(posedge i_b_clk, negedge i_b_reset_n)
	if (!i_b_reset_n)
		o_b_valid <= 1'b0;
	else if (!o_b_valid || i_b_ready)
		o_b_valid <= b_stb;
	// }}}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Formal properties
// {{{
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
`ifdef	FORMAL
	(* gclk *) reg gbl_clk;
			reg		f_past_valid_gbl, f_past_valid_a,
					f_past_valid_b;
	(* anyconst *)	reg	[3:0]	f_step_a,  f_step_b;
			reg	[4:0]	f_count_a, f_count_b;

	initial	f_past_valid_gbl = 0;
	always @(posedge gbl_clk)
		f_past_valid_gbl <= 1;

	initial	f_past_valid_a = 0;
	always @(posedge i_a_clk)
		f_past_valid_a <= 1;

	initial	f_past_valid_b = 0;
	always @(posedge i_b_clk)
		f_past_valid_b <= 1;

	always @(*)
	if (!f_past_valid_gbl)
		assume(!i_a_reset_n && !i_b_reset_n);

	////////////////////////////////////////////////////////////////////////
	//
	// Assume two clocks
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	always @(posedge gbl_clk)
	begin
		f_count_a <= f_count_a + { 1'b0, f_step_a } + 1;
		f_count_b <= f_count_b + { 1'b0, f_step_b } + 1;
	end

	always @(*)
		assume(i_a_clk == f_count_a[4]);
	
	always @(*)
		assume(i_b_clk == f_count_b[4]);
	
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Reset assumptions
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	// Both resets will always fall together
	always @(posedge gbl_clk)
		assume($fell(i_b_reset_n) == $fell(i_a_reset_n));

	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Stability properties
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	//
	// On clock A
	// {{{
	always @(posedge gbl_clk)
	if (!$rose(i_a_clk))
	begin
		assume(!$rose(i_a_reset_n));
		assume($stable(i_a_valid));
		assume($stable(i_a_data));
	end
	// }}}

	//
	// On clock B
	// {{{
	always @(posedge gbl_clk)
	if (!$rose(i_b_clk))
	begin
		assume(!$rose(i_b_reset_n));
		if (f_past_valid_b && i_b_reset_n && $stable(i_b_reset_n))
		begin
			assert($stable(o_b_valid));
			assert($stable(o_b_data));
		end
	end
	// }}}

	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Stream properties
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	always @(posedge i_a_clk)
	if (!f_past_valid_a || !i_a_reset_n)
		assume(!i_a_valid);
	else if ($past(i_a_valid && !o_a_ready))
	begin
		assume(i_a_valid);
		assume($stable(i_a_data));
	end

	always @(posedge i_b_clk)
	if (!f_past_valid_b || !i_b_reset_n)
		assert(!o_b_valid);
	else if ($past(o_b_valid && !i_b_ready))
	begin
		assert(o_b_valid);
		assert($stable(o_b_data));
	end


	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Induction
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	always @(posedge gbl_clk)
	case({ a_ack, a_pipe, b_ack, b_req, b_pipe, a_req })
	6'b000_000: begin end
	6'b000_001: begin end
	6'b000_011: begin end
	6'b000_111: begin end
	6'b001_111: begin end
	6'b011_111: begin end
	6'b111_111: begin end
	6'b111_110: begin end
	6'b111_100: begin end
	6'b111_000: begin end
	6'b110_000: begin end
	6'b100_000: begin end
	6'b000_000: begin end
	default: assert(0);
	endcase

	always @(posedge i_b_clk)
	if ({b_req, b_pipe} != 0)
		assert($stable(a_data));
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Cover checks
	// {{{
	////////////////////////////////////////////////////////////////////////
	//
	//

	reg	[3:0]	cvr_stbcount;
	initial	cvr_stbcount <= 0;
	always @(posedge i_b_clk, negedge i_b_reset_n)
	if (!i_b_reset_n)
		cvr_stbcount <= 0;
	else if (o_b_valid && (o_b_data[3:0] == cvr_stbcount))
		cvr_stbcount <= cvr_stbcount + 1;

	always @(*)
	begin
		cover(cvr_stbcount == 1);
		cover(cvr_stbcount == 2);
		cover(cvr_stbcount == 3);
		//
		// These next two take too much CPU time, so we don't insist
		// upon them here.
		// cover(cvr_stbcount == 4);
		// cover(cvr_stbcount == 5);
		// cover(cvr_stbcount == 6);
		// cover(cvr_stbcount[3]);
	end
	// }}}
`endif
// }}}
endmodule
