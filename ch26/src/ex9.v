always @ ( posedge clk ) begin
  my_flop_jk <= ( my_flop_jk | set_my_flop ) & ~( clear_my_flop & ~set_my_flop ); 
end
