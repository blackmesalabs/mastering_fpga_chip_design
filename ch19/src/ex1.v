  reg  [26:0]   cnt_1hz = 27'd99_999_999;
..
  if ( cnt_1hz == 27'd99_999_999 ) begin
    cnt_1hz <= 27'd99_999_990;
