////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	oddr.v
// {{{
// Project:	Formal methods example
//
// Purpose:	
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2020, Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
// }}}
module oddr #(
		parameter	OPT_METHOD = 2'b10
	) (
		// {{{
		input	wire		i_clk,
		input	wire		i_en,
		input	wire	[1:0]	i_data,
		output	reg		o_pad
		// }}}
	);

	generate if (OPT_METHOD == 2'b00)
	begin : NAIVE_METHOD
		// {{{
		reg	[1:0]	ddr_data;

		initial	ddr_data = 2'b00;
		always @(posedge i_clk)
		if (!i_en)
			ddr_data <= {(2){i_data[1]}};
		else
			ddr_data <= i_data;

		always @(*)
		if (i_clk)
			o_pad = ddr_data[1];
		else
			o_pad = ddr_data[0];
		// }}}
	end else if (OPT_METHOD == 2'b01)
	begin : FIRST_DRAFT
		// {{{
		reg	[1:0]	ddr_data;
		reg		cyclep, cyclen;

		initial	ddr_data = 2'b00;
		always @(posedge i_clk)
		if (!i_en)
			ddr_data <= {(2){i_data[1]}};
		else
			ddr_data <= i_data;

		initial	cyclep = 1'b0;
		always @(posedge i_clk)
			cyclep <= !cyclep;

		initial	cyclen = 1'b0;
		always @(negedge i_clk)
			cyclen <= cyclep;

		always @(*)
		begin
		o_pad =    (ddr_data[1] &&  cyclep && !cyclen)
			|| (ddr_data[1] && !cyclep &&  cyclen)
			|| (ddr_data[0] &&  cyclep &&  cyclen)
			|| (ddr_data[0] && !cyclep && !cyclen)
			|| (ddr_data[0] && ddr_data[1]);	
		end

		// }}}
	end else begin : BETTER_SOLUTION
		// {{{
		reg	cp, cnp, cn;

		initial	{ cp, cn, cnp } = 3'b000;
		always @(posedge i_clk)
		if (!i_en)
		begin
			if (i_data[1])
				{ cp, cnp } <= (cnp) ? 2'b01 : 2'b10;
			else
				{ cp, cnp } <= (cnp) ? 2'b11 : 2'b00;
		end else begin
			cp  <= i_data[1] ^ cnp;
			cnp <= i_data[0] ^ i_data[1] ^ cnp;
		end

		always @(negedge i_clk)
			cn <= cnp;

		always @(*)
			o_pad = cp ^ cn;
		// }}}
	end endgenerate

`ifdef	FORMAL
	(* gclk *) reg	gbl_clk;
	reg	[1:0]	f_data;

	always @(posedge gbl_clk)
		assume(i_clk != $past(i_clk));

	always @(posedge gbl_clk)
	if (!$rose(i_clk))
		assume($stable({ i_en, i_data }));

	initial	f_data = 2'b00;
	always @(posedge i_clk)
	if (!i_en)
		f_data <= {(2){i_data[1]}};
	else
		f_data <= i_data;

	always @(*)
	if (i_clk)
		assert(o_pad == f_data[1]);
	else
		assert(o_pad == f_data[0]);
`endif
endmodule
