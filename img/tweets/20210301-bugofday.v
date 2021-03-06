

	always @(something)
	if (detect_new_command_issue)
	case(new_command)
	CMD_A: do_task_a;
	CMD_B: do_task_b;
	CMD_C: do_task_c;
	// ...
	endcase
