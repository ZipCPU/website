
	always @(posedge S_AXI_ACLK)
	if (S_AXI_ARESETN)
		counter <= 0;
	else if (S_AXI_TVALID && S_AXI_TREADY)
	begin
		counter <= counter + 1;
		if (S_AXI_TLAST)
			counter <= 0;
	end



