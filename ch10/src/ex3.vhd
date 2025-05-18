LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity rom_font  is
port
(
  clk   : in  std_logic;
  addr  : in  std_logic_vector(11 downto 0);
  data  : out std_logic_vector(7 downto 0)
);
end rom_font;

 architecture rtl of rom_font is
 type rom_type is array (0 to 4095) of std_logic_vector(7 downto 0);
 constant rom : rom_type := (
     X"00",
....
     X"10",
     X"38",
     X"7c",
     X"fe",
     X"7c",
     X"38",
     X"10",
....
     X"00",
     X"00",
     X"00"
  );

begin
----------------------------------------------------------------
-- Flop Process
----------------------------------------------------------------
flop_proc : process ( clk )
begin
  if ( clk'event and clk = '1' ) then
    data <= rom( conv_integer( addr ) );
  end if;
end process flop_proc;

end rtl;
