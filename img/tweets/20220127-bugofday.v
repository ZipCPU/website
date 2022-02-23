
	task tbscript;
	begin
		// Interact with device model
		//   ...
		//   Get a returned result

		if (returned_result != expected_result)
		begin
			success_flag = 1'b0;
			$display("Returned value != Expected value");
		end

	end

	// Problems: if the returned_result contains an 'x, the entire
	// condition will evaluate to 'x.  Any "if" depending on an 'x
	// condition will evaluate the "else" clause of the if rather
	// than the main cause.

	// This check, therefore, would always fail to flag a problem if
	// the returned result ever contained an 'x in any bit


// Versus the updated construct below:

		if (1'b1 === (returned_result == expected_result))
		begin end else begin
			success_flag = 1'b0;
			$display("Returned value != Expected value");
		end

		// If any of the returned_result is 'x, the whole condition
		// will be 'x.

		// Checking for === returns true if all bits, whether 1'b1,
		// 1'b0, 1'bx, or 1'bz, match.  It will only ever return 1'b1
		// or 1'b0.

		// Should an "if" condition ever evaluate to 1'bx (which
		// this one won't), the "else" would be executed, not the "if".




