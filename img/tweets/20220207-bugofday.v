`timescale 1ns / 100ps
module tb;
	reg	clk;
	parameter	time	dT = 0.2;

	initial	clk = 0;
	always
		#dT clk = !clk;


	initial begin
		$dumpfile("ictest.vcd");
		$dumpvars(0, tb);

		#20;
		$finish;
	end
endmodule

