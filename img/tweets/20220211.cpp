
unsigned	CLOCK_FREQUENCY_HZ = 100 * 1000 * 1000; // 100 MHz

// Convert wait time in seconds to clock cycles in seconds.  Round to the
// nearest integer number of cycles as necessary.
unsigned wait_cycles(double wait_time_s) {
	double	clock_period_s = 1.0 / CLOCK_FREQUENCY_HZ;
	// You may assume that wait_time_s is less than 2^32 clock cycles

	return (unsigned)(wait_time_s + clock_period_s/2.0) / clock_period_s;
}


