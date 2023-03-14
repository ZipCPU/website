

	// ECC polynomial residue
	always @(posedge S_ACLK or negedge S_ARESETN)
	if(!S_AXI_ARESETN)
		r_residue <= INITIAL_POLY;
	else if (!i_calc_parity_en || S_LAST)
		r_residue <= INITIAL_POLY;
	else if (S_VALID)	// S_READY is fixed at 1'b1
		r_residue <= bit_calc[ENC_BIT_WIDTH-1]; 



