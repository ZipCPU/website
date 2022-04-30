

always @(posedge S_AXI_ACLK)
if (!S_AXI_ARESETN)
	// Clear the checksum calculator on reset
	{ ip_carry, ip_checksum } <= 0;
else if (state == S_IDLE || prior_to_the_ip_header)
	// Clear the checksum before calculating it
	{ ip_carry, ip_checksum } <= 0;
else if (S_AXIN_VALID && S_AXIN_READY)
begin
	if (state == S_IPHEADER)
	begin
		// Calculate the IP Header checksum
		if (!addr[0])
			{ ip_carry, ip_checksum[15:8] } <= ip_checksum[ 7:0] + (ip_carry ? 1:0) + S_AXIN_DATA;
		else
			{ ip_carry, ip_checksum[ 7:0] } <= ip_checksum[15:8] + (ip_carry ? 1:0) + S_AXIN_DATA;
	end else if (ip_carry)
	begin
		// Deal with any remaining
		if (!addr[0])
			{ ip_carry, ip_checksum[15:8] } <= ip_checksum[ 7:0] + (ip_carry ? 1:0);
		else
			{ ip_carry, ip_checksum[ 7:0] } <= ip_checksum[15:8] + (ip_carry ? 1:0);
	end
end


