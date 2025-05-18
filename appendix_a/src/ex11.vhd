 type rom_type is array (0 to 255) of std_logic_vector(7 downto 0);
 constant rom : rom_type := 
(
     X"00",
     ..
     X"38"
);

proc_rom : process ( clk )
begin
  if ( clk'event and clk = '1' ) then
    data <= rom( conv_integer( addr ) );
  end if;
end process proc_rom;
