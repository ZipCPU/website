

	// This works with XCellium, but generates
	//   an infinite loop when using Synopsis' VCS
	reg	[31:0]	D1, D2;
	reg	[4:0]	LN;
	integer	k;

	always @(*)
	begin
		D1 = 0
		for(k=0; k<LN; k=k+1)
			D1[LN-1-k] = S[31-k];
	end


	always @(*)
	begin
		D2 = 0
		for(k=0; k<LN; k=k+1)
			D2[LN-1-k] = 1'b1;
	end


