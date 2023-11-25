module	axi_addr #(
		// ...
		parameter	AW = 32,	// AXI bus address width
				DW = 32		// AXI bus data width
	) (
		// ...
		input	wire	[2:0]	i_size, // AXI size: 1b, 2b, 4b, 8b, etc
		// ...
	);

	localparam		DSZ = $clog2(DW)-3;	// Maximum size
	localparam		IN_AW = (AW >= 12) ? 12 : AW;

	reg	[IN_AW-1:0]	increment;

	always @(*)
	if (DSZ == 0)
		increment = 1;
	else if (DSZ == 1)
		increment = (i_size[0]) ? 2 : 1;
	else if (DSZ == 2)
		increment = (i_size[1]) ? 4 : ((i_size[0]) ? 2 : 1);
	else if (DSZ == 3)
		case(i_size[1:0])
		2'b00: increment = 1;
		2'b01: increment = 2;
		2'b10: increment = 4;
		2'b11: increment = 8;
		endcase
	else
		increment = (1<<i_size);	// << LINT ERROR

	// ...
endmodule
