  cnt_a[7:0] <= cnt_a[7:0] + 1;
  cnt_a_roll <= cnt_a_roll_pre;
  if ( cnt_a[7:0] == 8'hFD ) begin 
    cnt_a_roll_pre <= 1;
  end
  if ( cnt_a_roll == 1 ) begin
    cnt_b <= cnt_b[7:0] + 1;
  end
