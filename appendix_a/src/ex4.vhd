process ( clk ) begin
 if ( clk'event and clk = '1' ) then
   a <= b;
 end if;
end process;
