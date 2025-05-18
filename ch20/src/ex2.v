always @ ( posedge clk_100m ) begin
  if ( my_prescaler == 17'd9_999 || sim_mode == 1 ) begin
    my_prescaler <= 17'd0;
    pulse_1ms    <= 1;
  end else begin
    my_prescaler <= my_prescaler[16:0] + 1;
    pulse_1ms    <= 0;
  end

  done <= 0;
  if ( my_cnt != 14'd0 && pulse_1ms == 1 ) begin
    my_cnt <= my_cnt[13:0] + 1;
  end
  if ( my_cnt == 14'd10_000 ) begin
    my_cnt <= 14'd0;// Halt
    done   <= 1;
  end
  if ( start == 1 ) begin
    my_cnt <= 14'd1;// Start
  end
end
