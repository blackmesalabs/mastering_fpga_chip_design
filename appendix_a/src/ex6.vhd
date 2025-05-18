process ( clk, reset ) begin
  if ( reset = '1' ) then
    reset_pre  <= '1';
    reset_sync <= '1';
  elsif ( clk'event and clk = '1' ) then
    reset_pre  <= '0';
    reset_sync <= reset_pre;
  end if;
end process;
