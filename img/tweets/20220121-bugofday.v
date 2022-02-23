
	assign	FILL = WPTR - RPTR;

	task WRITE(input [DW-1:0] DATA)
	begin
		// ...
		DONE = 0;
		while(!DONE)
		begin
			if (FILL + 1 <= FIFOSIZE)
			begin
				FIFOMEM[WPTR] = DATA;
				WPTR = WPTR + 1;
				DONE = 1;
			end else
				@(posedge CLK);
		end
	end

	task TEST;
	begin
		// ...
		WRITE(D1);	// Write some data to
		WRITE(D2);	// the FIFO.  The Dx
		WRITE(D3);	// values are arbitrary.
		WRITE(D4);
		WRITE(D5);
		// ...
	end



