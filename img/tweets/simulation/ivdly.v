// Verilog simulation
// -- This follows directly from the data sheet
always @(posedge trigger or negedge clear)
if (!clear)
	signal <= 0;
else begin
	signal <= #RESPONSE_TIME data_value;
	signal <= #(RESPONSE_TIME + DATA_VALID_TIME) 1'bz;
end


// Verilator simulation
// -- Proposed conversion of the logic above
// -- Based upon an artificial, needs to be generated, verilator_clock
// -- Timing signals also need to be quantized
always @(posedge verilator_clock)
	last_trigger <= trigger;

always @(posedge verilator_clock)
if (!clear)
	signal_sreg <= 0;
else if (!last_trigger && trigger)
begin
	signal_sreg <= signal_sreg >> 1;
	signal_sreg[MSB-1] <= $random;
	signal_sreg[(DATA_VALID_CK+RESPONSE_CK)-1:RESPONSE_CK]
		<= {(DATA_VALID_CK){data_valid}};
end

assign	signal = signal_sreg[0];


