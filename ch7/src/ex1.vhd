LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std;

entity my_74193 is
port
(
  clk     : in  std_logic;
  reset   : in  std_logic;
  load_en : in  std_logic;
  inc_en  : in  std_logic;
  dec_en  : in  std_logic;
  din     : in  std_logic_vector( 3 downto 0 );
  dout    : out std_logic_vector( 3 downto 0 )
);
end my_74193;

architecture rtl of my_74193 is

  signal my_cnt : std_logic_vector(3 downto 0 ) := "0000"; 

begin

process ( clk, reset )
begin
  if ( reset = '1' ) then
    my_cnt <= "0000";
  elsif ( clk'event and clk = '1' ) then
    if    ( load_en = '1' ) then
      my_cnt <= din(3 downto 0);
    elsif ( inc_en  = '1' ) then
      my_cnt <= my_cnt(3 downto 0) + '1';
    elsif ( dec_en  = '1' ) then
      my_cnt <= my_cnt(3 downto 0) - '1';
    end if;
  end if;
end process;
  dout <= my_cnt(3 downto 0);

end rtl;-- my_74193.vhd
