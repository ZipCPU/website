
	function [PLEN-1:0]	RUN_POLY(input [31:0] BITS,
					input [PLEN-1:0] state,
					input [PLEN-1:0] POLY);
		reg [PLEN-1:0]	fn_state;
		integer		ik;
	begin
		fn_state = state;
		for(ik=0; ik < BITS; ik=ik+1)
		if (fn_state[PLEN-1])
			fn_state = { fn_state[PLEN-2:0], 1'b0 } ^ POLY;
		else
			fn_state = { fn_state[PLEN-2:0] };
	end endfunction


