always @ ( posedge clk ) begin
  if ( clear_my_flop == 1 ) begin
    my_flop_jk <= 0;
  end
  if ( set_my_flop == 1 ) begin
    my_flop_jk <= 1;
  end
end
