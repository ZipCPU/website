`timescale 1ns/1ps
module // ...
	parameter	FF_HOLD = 2;	// 2ns
	// ...

	// This is part of a test bench, and used to feed a scoreboard
	// to check whether data going into the channel matches data
	// coming out.  We use this to test both the source data logic
	// and the sink data logic.

	//
	// clk is rather slow, running sub 100MHz
	//

	always @(posedge clk or negedge clk or negedge reset)
	if (!reset)
		sb_ptr <= 0;
	else if (!channel_active)
		sb_ptr <= #FF_HOLD 0;
	else if ((!source_channel && !clk && read_data_word)
			|| (source_channel && new_data_word))
		// read_data_word is only adjusted on posedge clk
		//	We check for it to keep from incrementing here twice
		// new_data_word may be updated on both edges of the clock
		sb_ptr <= #FF_HOLD sb_ptr + 1;




