
	// Goal: Model an external device
	//
	// Criteria:
	//   The master (DUT) will reset the external slave--to
	//   be modeled herein.
	//   1. While the master asserts reset, the slave
	//      shall assert its reset return.
	//   2. Once the master releases the reset, the slave
	//      shall release its reset #tRESET ns later.
	//   3. Both resets are asynchronous and use negative
	//      logic.

	// Original implementation (BROKEN)
	always @(negedge master_reset_n)
		slave_reset_return <= 1'b0;

	always @(posedge master_reset_n)
		slave_reset_return <= #tRESET 1'b1;

	// First attempted fix (ALSO BROKEN)
	assign	#tRESET slave_reset_return = master_reset_n;


	// Chosen solution
	localparam	nRESET= ($rtoi(tRESET)+1)/2;	// Convert to ns/2
	reg		internal_clk;
	reg	[11:0]	reset_release_counter;

	initial	internal_clk = 0;
	always
		#1 internal_clk = !internal_clk;	// Count in ns/2

	initial	slave_reset_return = 1'b0;
	initial	reset_release_counter = 12'h0;
	always @(posedge internal_clk or negedge master_reset_n)
	if (!master_reset_n)
	begin
		slave_reset_return <= 1'b0;
		reset_release_counter <= 12'h0;
	end else if (reset_release_counter < nRESET)
		reset_release_counter <= reset_release_counter + 1;
	else
		slave_reset_return <= 1'b1;




