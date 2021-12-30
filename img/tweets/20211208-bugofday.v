
	always @(posedge S_AXI_ACLK)
	if (reset)
		counter <= 0;
	else if (condition)
	begin
		counter <= counter + (step_by_two) ? 2:1;
	end



