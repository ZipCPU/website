module ctr17 #(
		// {{{
		parameter		 DW = 12,
		parameter [DW-1:0]	MAX_VALUE = 12'h7de
		// }}}
	) (
		// {{{
		input	wire		i_clk,
		input	wire		i_reset,
		input	wire		i_start,
		output	wire		o_done
		// }}}
	);

	reg	[DW-1:0]	counter;
	reg			zero_counter;

	always @(posedge i_clk)
	if (i_reset)
		counter <= 0;
	else if (counter > 0)
		counter <= counter - 1;
	else if (i_start)
		counter <= MAX_VALUE;


	always @(posedge i_clk)
	if (i_reset)
		zero_counter <= 1;
	else if (counter > 0)
	begin
		if (counter == 1)
			zero_counter <= 1;
	end else if (i_start)
		zero_counter <= 0;

`ifdef	FORMAL
	reg	f_past_valid;

	initial	f_past_valid = 0;
	always @(posedge i_clk)
		f_past_valid <= 1;

	always @(*)
	if (!f_past_valid)
		assume(i_reset);

	always @(posedge i_clk)
	if (f_past_valid && !$past(i_reset) && $past(counter == 1))
		assert($rose(zero_counter));

	// always @(*)
	// if (f_past_valid)
	//	assert(zero_counter == (counter == 0));
`endif
endmodule
