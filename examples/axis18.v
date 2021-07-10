module axis18 #(
		parameter	DW = 16
	) (
		input	wire			S_AXI_ACLK, S_AXI_ARESETN,
		//
		input	wire			S_AXIS_TVALID,
		output	reg			S_AXIS_TREADY,
		input	wire	[DW-1:0]	S_AXIS_TDATA,
		input	wire			S_AXIS_TLAST,
		//
		output	reg			M_AXIS_TVALID,
		input	wire			M_AXIS_TREADY,
		output	reg	[DW-1:0]	M_AXIS_TDATA,
		output	reg			M_AXIS_TLAST
	);

	always @(posedge S_AXI_ACLK)
	if (!S_AXI_ARESETN)
	begin
		M_AXIS_TVALID <= 0;
		S_AXIS_TREADY <= 0;
	end else if (S_AXIS_TVALID && !S_AXIS_TREADY
			&& (!M_AXIS_TVALID || M_AXIS_TREADY))
	begin
		S_AXIS_TREADY <= 1;

		M_AXIS_TVALID <= 1;
		M_AXIS_TDATA  <= S_AXIS_TDATA;
		M_AXIS_TLAST  <= S_AXIS_TLAST;
	end else begin
		if (M_AXIS_TREADY)
			M_AXIS_TVALID <= 0;
		S_AXIS_TREADY <= 0;
	end

`ifdef	FORMAL
	reg	f_past_valid;
	(* gclk *) reg gbl_clk;

	initial	f_past_valid = 0;
	always @(posedge S_AXI_ACLK)
		f_past_valid <= 1;

	always @(*)
	if (!f_past_valid)
		assume(!S_AXI_ARESETN);

	always @(posedge gbl_clk)
	if (!$rose(S_AXI_ACLK))
	begin
		assume(!$rose(S_AXI_ARESETN));

		assume($stable(S_AXIS_TVALID));
		assume($stable(S_AXIS_TDATA));
		assume($stable(S_AXIS_TLAST));

		assume($stable(M_AXIS_TREADY));
	end

	always @(posedge S_AXI_ACLK)
	if (!f_past_valid || $past(!S_AXI_ARESETN))
		assume(!S_AXIS_TVALID);
	else if ($past(S_AXIS_TVALID && !S_AXIS_TREADY))
	begin
		assume(S_AXIS_TVALID);
		assume(S_AXIS_TDATA == $past(S_AXIS_TDATA));
		assume($stable(S_AXIS_TLAST));
	end

	always @(posedge S_AXI_ACLK)
	if (!f_past_valid || $past(!S_AXI_ARESETN))
		assert(!f_past_valid || !M_AXIS_TVALID);
	else if ($past(M_AXIS_TVALID && !M_AXIS_TREADY))
	begin
		assert(M_AXIS_TVALID);
		assert($stable(M_AXIS_TDATA));
		assert($stable(M_AXIS_TLAST));
	end

	always @(*)
	if (f_past_valid && S_AXI_ARESETN && S_AXIS_TREADY)
	begin
		assert(M_AXIS_TVALID);
		assert(S_AXIS_TVALID);
		assert(S_AXIS_TDATA == M_AXIS_TDATA);
	end
`endif
endmodule
