
	always @(A or B or C or D or /* ... */) // LOTS of conditions
	case(current_state)
	POWER_ON_RESET: if (reset)
			A = 1'b0;
		else
			A = 1'b1;
	// case continues ....
	endcase



