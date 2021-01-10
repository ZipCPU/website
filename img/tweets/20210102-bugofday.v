
	always @(posedge iw_clk)
	begin
		for (i = 0; i < MAX; i = i + 1)
		if (CONDITION_BASED_ON_INDEX)
			A <= 1;
		else
			A <= 0;
	end




