// (Throughout)
//   W,CTLCHR: HDL source line contains one or more control characters
module linttest #(
		parameter W = 16
		//   W,PRMBSE: Base not specified
		//   W,PRMVAL: Bit-width not specified
	) (
		input	wire		i_clk, i_reset,
		input	wire		i_inc, i_add, i_set, i_load,
		input	wire	[W-1:0]	i_val,
		output	reg	[W-1:0]	o_acc
	);

	initial	o_acc = 0;
	always @(posedge i_clk)
	//   W,NBGEND: Missing begin/end statement
	//   W,OLDALW: Old coding style for always block, use always_ff instead
	if (i_reset)
		// Reset clears all bits
		//   W,FFWASR: FF has no asynchronous set or reset
		// 	(It has a synchronous reset the tool doesn't notice)
		//   W,TRUNCZ: Truncation in constant
		//   W,IMPDTC: Expression '0' implicitly converted to UNSIGNED
		//   W,NBGEND: Missing begin/end statement
		o_acc <= 0;
	else if (i_set)
		// Set all bits
		//   W,TRUNCZ: Truncation in constant
		//   W,NBGEND: Missing begin/end statement
		//   W,SGNUSG: Negative values assigned to an unsigned variable
		o_acc <= -1;
	else if (i_load)
		// Load a value
		//   W,NBGEND: Missing begin/end statement
		o_acc <= i_val;
	else if (i_add)
		// Add a value
		//   W,POIASG: Addition may lead to overflow
		//   W,LRGOPR: Arithmetic operation performed on large operands
		//   W,NBGEND: Missing begin/end statement
		o_acc <= o_acc + i_val;
	else if (i_inc)
		// Increment
		//   W,POIASG: Addition may lead to overflow
		//   W,UELOPR: Unequal length operand in arithmetic PLUS
		//   W,IMPDTC: Expression implicitly converted from int to reg
		//   W,LRGOPR: Arithmetic operation performed on large operands
		//   W,NBGEND: Missing begin/end statement
		o_acc <= o_acc + 1;

endmodule
//
// hal -SV -DATE -RACES test.v -TOP test
