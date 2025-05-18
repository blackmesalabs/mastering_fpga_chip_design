type ram_type is array (255 downto 0) of std_logic_vector(7 downto 0);
shared variable ram_array : ram_type;

process( a_clk )
begin
  if a_clk'event and a_clk = '1' then
    ram_array(conv_integer( a_addr )) := a_di(7 downto 0);
  end if;
end process;

process( b_clk )
begin
  if b_clk'event and b_clk = '1' then
    b_do <= ram_array(conv_integer(b_addr));
  end if;
end process;
