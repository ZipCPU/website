


	task some_task;
	begin
		// ...
		// Wait for signal_one
		wait(signal_one);
		#delay_X;
		wait(posedge signal_two);
		// Do something important
		// ...
	end endtask

	always @(posedge signal_one)
	begin
		#delay_X;
		signal_two = 1'b1;
	end



