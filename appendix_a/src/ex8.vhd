process ( clk )
begin
  if ( clk'event and clk = '1' ) then
    if ( reset = '1' ) then
      cnt <= X"00";
    else
      cnt <= cnt(7 downto 0) + '1';
    end if;
  end if;
end process;
