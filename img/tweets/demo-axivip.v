// From within the top level ...
`include `TEST_SCRIPT

// (Then, from a user selected TEST_SCRIPT ...)
initial begin
	while(ARESETN)
		@(posedge ACLK);

	AXIVIP.writebus(R_CONFIG_ONE, C_SOME_VALUE);
	AXIVIP.writebus(R_CONFIG_TWO, C_SOME_OTHER_VALUE);

	for(ik=0; ik<DATA_BURSTS; ik=ik+1)
	begin
		AXIVIP.readbus(R_DATA, data_value);
		// Validate: data_value
		//
		// This naturally places delays between
		// each AXI read command
	end

end




