integer	ik;

initial begin
	ARESETN = 1'b0;
	for(ik=0; ik<16; ik=ik+1)
		@(posedge ACLK);
	@(posedge ACLK)
		ARESETN <= 1'b1;

	@(posedge ACLK)
	begin
		ARVALID <= 1'b1;
		ARADDR  <= DEV_ADDR;
	end

	ik = 0;
	while(ik < 16)
	@(posedge ACLK)
	if (ARVALID && ARREADY)
		ik <= ik + 1;
end


