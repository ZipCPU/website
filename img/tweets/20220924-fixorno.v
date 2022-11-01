

  always@(posedge A or negedge internal_signal)
    begin
      #0.01;
      if(A && mode_one)
        begin
	  #t_wait_time_from_spec;
	  output_enable = 1'b0;
	end
      if(A && mode_two)
	 output_enable = 1'b0;
      if(mode_three && chip_enable)
         begin
         output_enable = 1'b0;
         end
    end



