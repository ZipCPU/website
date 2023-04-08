
	// Given a frame cols columns wide, answer the
	//   question, are we on the first column between
	//   either 4--12, or 24--30 inclusive

	assign A = ((B % cols)==0 && ((B >= cols*8'd4) && (B <= cols * 8'd12))
			| ((B >= cols * 8'd24) && (B <= cols * 8'd30)));


