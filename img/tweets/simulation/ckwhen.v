
	initial	ACLK = 0;
	always @*
		#5 ACLK = !ACLK;

	generate if (BROKEN)
	begin

		initial begin
			// Trigger a negative edge
			ARESETN = 1'b0;

			#15;
			// End reset
			// Question: Does the reset get released before or after
			// the clock tick?
			ARESETN = 1'b1;
		end

	end else begin

		initial	begin
			// Trigger an asynchronous negative edge
			ARESETN = 1'b0;
			@(posedge ACLK);

			// Force the release to be synchronous
			@(posedge ACLK)
				ARESETN <= 1'b1;
		end

	end endgenerate

	initial begin : TEST_SCRIPT
		// ... Perhaps start with some setup tasks
		// This setup may (or may not) leave us aligned with the
		// clock
		setup_task;
		#10;

		// Now ... is AWVALID raised before or after the clock?
		// Does it matter if the setup_task was clock aligned?
		AWVALID = 1'b1;

		// Test script continues
		// ...
	end


