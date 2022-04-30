
	// This design works in simulation, but not all parts yet work in
	// hardware.
	//
	// The following lines will select from among several internal
	// logic analyzer sources, to help me chase down any bugs.
	//
	initial	r_debugsel = 3'b100;
	always @(posedge i_clk)
	if (i_wb_stb && i_wb_stb && i_wb_addr == 8 && i_wb_sel[3])
		r_debugsel <= i_wb_data[30:28];



