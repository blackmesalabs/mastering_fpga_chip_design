process ( clk, reset ) begin
  if ( reset = '1' ) then
    a <= '0';
  elsif ( clk'event and clk = '1' ) then
    a <= b;
  end if;
end process;
