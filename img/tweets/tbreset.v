
`timescale 1ns / 1ps
module testbench;

	// ...

	parameter real	CLK_PERIOD = 1.25;	// 800 MHz

	initial begin
		clk <= 1'b0;
		forever #(CLK_PERIOD / 2.0)
			clk = !clk;
	end

	initial begin
		areset_n <= 1'b0;
		@(posedge clk);
		@(posedge clk)
			areset_n <= 1'b1;
	end

	// ...

endmodule


