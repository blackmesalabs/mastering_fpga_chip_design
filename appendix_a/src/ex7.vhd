process ( b, c ) begin
  if ( b = '1' and c = '0' ) then
    a <= '1';
  else
    a <= '0';
  end if;
end process;
