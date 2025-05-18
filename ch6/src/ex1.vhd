LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std;

entity top is
port
(
  clk : in  std_logic;
  led : out std_logic_vector( 3 downto 0 )
);
end top;

architecture rtl of top is

  signal clk_100m_loc   : std_logic;
  signal clk_100m_tree  : std_logic;
  signal my_cnt         : std_logic_vector(3 downto 0 ) := "0000";
  signal pulse_1hz      : std_logic := '1';

begin

  clk_100m_loc  <= clk;          -- Infer IBUF
  clk_100m_tree <= clk_100m_loc; -- Infer BUFG

process ( clk_100m_tree )
begin
  if ( clk_100m_tree'event and clk_100m_tree = '1' ) then
    if ( pulse_1hz = '1' ) then
      my_cnt <= my_cnt(3 downto 0) + '1';
    end if;
  end if;
end process;
  led <= my_cnt(3 downto 0);

end rtl;-- top.vhd
