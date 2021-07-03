

	static volatile char *const _sram = (char *)(SRAM_DEVICE_ADDRESS);

	printf("FEATURE(%2d): %02x:%02x:%02x:%02x\n", 1,
		_sram[0], _sram[1],
		_sram[2], _sram[3]);

	check = ((_sram[0] & 0x0ff) << 24)
		| ((_sram[1] & 0x0ff) << 16)
		| ((_sram[2] & 0x0ff) <<  8)
		| (_sram[3] && 0x0ff);



