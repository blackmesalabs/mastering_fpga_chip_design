library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is
port
(
  reset  : in  std_logic;
  clk    : in  std_logic;
  load   : in  std_logic;
  din    : in  std_logic_vector(3 downto 0);
  dout   : out std_logic_vector(3 downto 0)
);
end counter;

architecture rtl of counter is

  signal my_cnt : std_logic_vector(3 downto 0) := X"0";

begin

process ( clk )
begin
 if ( clk'event and clk = '1' ) then
   if ( reset = '1' ) then
     my_cnt <= X"0";
   else
     if ( load = '1' ) then
       my_cnt <= din(3 downto 0);
     else
       my_cnt <= my_cnt(3 downto 0) + '1';
     end if;
   end if;
 end if;
end process;
  dout <= my_cnt(3 downto 0);

end rtl;
