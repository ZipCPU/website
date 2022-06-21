
	always @(posedge S_AXI_ACLK)
	if (!M_AXI_WVALID || M_AXI_WREADY)
	begin : BIGENDIAN_ORDER

		M_AXI_WSTRB <= next_wstrb;
		next_wstrb  <= 0;

		if (i_cpu_mem_request) // Will only happen if next_wstrb == 0
		casez(i_cpu_request_type[2:1])
		2'b0?: { M_AXI_WSTRB, next_wstrb } // 32-bit Word operation
			<= { 4'b1111, {(C_AXI_DATA_WIDTH/8-4){1'b0}} }
					>> i_cpu_request_addr[AXILLSB-1:0];
		2'b10: { M_AXI_WSTRB, next_wstrb } // 16-bit Half-word operation
			<= { 2'b11, {(C_AXI_DATA_WIDTH/8-2){1'b0}} }
					>> i_cpu_request_addr[AXILLSB-1:0];
		2'b11: { M_AXI_WSTRB, next_wstrb } // 8-bit Byte operation
			<= { 1'b0, {(C_AXI_DATA_WIDTH/8-1){1'b0}} }
					>> i_cpu_request_addr[AXILLSB-1:0];
		endcase
	end



