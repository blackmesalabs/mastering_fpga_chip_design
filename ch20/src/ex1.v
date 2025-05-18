always @ ( posedge clk_100m ) begin
  done <= 0;
  if ( my_cnt != 30'd0 ) begin
    my_cnt <= my_cnt[29:0] + 1;
  end
  if ( my_cnt == 30'd1_000_000_000 ) begin
    my_cnt <= 30'd0;// Halt
    done   <= 1;
  end
  if ( start == 1 ) begin
    my_cnt <= 30'd1;// Start
  end
end
