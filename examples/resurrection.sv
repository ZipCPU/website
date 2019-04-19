`default_nettype	none
//
//
module	resurrection(
	input	wire		i_clk,
	input	wire		i_last_supper,
	input	wire		i_gethsemane,
	input	wire		i_crucifixion,
	input	wire		i_prepare_spices,
	input	wire		i_request_guards,
	input	wire		i_resurrection,
	input	wire		i_tomb_visit,
	input	wire		i_preparation_day,
	input	wire		i_sabbath,
	output	reg		o_valid);

	reg	[3:0]	time_of_week;
	(* keep *) wire		sunday, monday, tuesday, wednesday,
			thursday, friday, saturday,
			daytime, nighttime,
			three_days, three_nights;
	reg	[2:0]	buried_days, buried_nights;
	reg		crucified, in_the_tomb, spices_prepared,
			tomb_guarded, day_after_preparation_day;

	initial	time_of_week = 0;
	always @(posedge i_clk)
	if (time_of_week >= 13)
		time_of_week <= 0;
	else
		time_of_week <= time_of_week + 1;

	assign	nighttime = (time_of_week[0] == 0);
	assign	daytime   = !nighttime;
	assign	sunday    = (time_of_week[3:1] == 0);
	assign	monday    = (time_of_week[3:1] == 1);
	assign	tuesday   = (time_of_week[3:1] == 2);
	assign	wednesday = (time_of_week[3:1] == 3);
	assign	thursday  = (time_of_week[3:1] == 4);
	assign	friday    = (time_of_week[3:1] == 5);
	assign	saturday  = (time_of_week[3:1] == 6);

	//
	// Sabbath properties
	//
	assume	property (@(posedge i_clk) saturday |-> i_sabbath);
	assume	property (@(posedge i_clk) daytime |-> !$changed(i_sabbath));

	//
	// Last Supper properties
	//

	assume	property (@(posedge i_clk) !daytime |-> !i_last_supper);
	assume	property (@(posedge i_clk)  i_last_supper |=>  i_gethsemane);
	assume	property (@(posedge i_clk) !i_last_supper |=> !i_gethsemane);
	//
	// The Garden of Gethsamane
	//

	assume	property (@(posedge i_clk) !nighttime |-> !i_gethsemane);
	assume	property (@(posedge i_clk) i_gethsemane |=> i_crucifixion);
	assume	property (@(posedge i_clk) !i_gethsemane |=> !i_crucifixion);

	//
	// The Day of the Crucifixion
	//

	assume	property (@(posedge i_clk) !daytime |-> !i_crucifixion);
	assume	property (@(posedge i_clk) i_sabbath |-> !i_crucifixion);
	assume	property (@(posedge i_clk) i_crucifixion |=> i_sabbath);

	// The preparation day
	assume property (@(posedge i_clk) !daytime |-> !i_preparation_day);
	assume property (@(posedge i_clk) i_preparation_day |-> ##2 i_sabbath);
	assume property (@(posedge i_clk) daytime && !i_preparation_day
			|-> ##2 !i_sabbath);
	assert property (@(posedge i_clk) i_crucifixion |-> i_preparation_day);
	initial	crucified = 0;
	always @(posedge i_clk)
	if (i_crucifixion)
		crucified <= 1;

	assume	property (@(posedge i_clk) crucified |-> !i_crucifixion);

	//
	// Counting Three Days and Three Nights
	//
	initial	in_the_tomb = 0;
	always @(posedge i_clk)
	if (i_crucifixion)
		in_the_tomb <= 1;
	else if (buried_days + buried_nights == 5)
		in_the_tomb <= 0;

	initial	buried_days = 0;
	always @(posedge i_clk)
	if (i_crucifixion)
		buried_days <= 0;
	else if (daytime && in_the_tomb)
		buried_days <= buried_days + 1;

	initial	buried_nights = 0;
	always @(posedge i_clk)
	if (i_crucifixion)
		buried_nights <= 0;
	else if (nighttime && in_the_tomb)
		buried_nights <= buried_nights + 1;

	assign	three_days   = (buried_days   == 3);
	assign	three_nights = (buried_nights == 3);

	assert	property (@(posedge i_clk)
		crucified && !in_the_tomb
		|-> three_days && three_nights);

	//
	// The Spices and the Soldiers
	//
	assume	property (@(posedge i_clk) (!in_the_tomb || i_sabbath
			|| nighttime) |-> ! i_prepare_spices);

	initial	spices_prepared = 0;
	always @(posedge i_clk)
	if (i_prepare_spices)
		spices_prepared <= 1;


	initial	day_after_preparation_day = 0;
	always @(posedge i_clk)
	if (i_preparation_day)
		day_after_preparation_day = 1;
	else if (daytime)
		day_after_preparation_day = 0;

	assume property (@(posedge i_clk) !daytime || !day_after_preparation_day
		|-> !i_request_guards);

	initial	tomb_guarded = 0;
	always @(posedge i_clk)
	if (i_request_guards)
		tomb_guarded <= 1;
	else if (i_tomb_visit)
		tomb_guarded <= 0;

	//
	// Resurrection Day
	//
	assume property (@(posedge i_clk) in_the_tomb || !crucified
		|-> !i_resurrection);

	always @(posedge i_clk)
		assume(i_resurrection == $fell(in_the_tomb));

	assume property (@(posedge i_clk) !sunday |-> !i_tomb_visit);

	assume property (@(posedge i_clk)
		!(spices_prepared && sunday && daytime && !in_the_tomb
		&& tomb_guarded) -> !i_tomb_visit);

	assign	o_valid = i_tomb_visit;

	cover	property (@(posedge i_clk) o_valid);

endmodule
