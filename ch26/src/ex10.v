always @ ( posedge clk_a ) begin
  pulse_clr_meta <= pulse_clr;
  pulse_clr_sr   <= { pulse_clr_sr[0], pulse_clr_meta };
  if ( pulse_a == 1 ) begin
    pulse_a_jk <= 1;
  end else if ( pulse_clr_sr[1] == 1 ) begin
    pulse_a_jk <= 0;
  end
end

always @ ( posedge clk_b ) begin
  pulse_b_meta <= pulse_a_jk;
  pulse_b_sr   <= { pulse_b_sr[1:0], pulse_b_meta };
  pulse_clr    <= pulse_b_sr[2];
  pulse_b      <= pulse_b_sr[1] & ~ pulse_b_sr[2];
end
