
	always @(posedge i_clk)
	if (condition)
		assert(A);
	else
		assert(B);




	always @(posedge i_clk)
	if (condition)
	begin
		assert(A);
	end else
		assert(B);
