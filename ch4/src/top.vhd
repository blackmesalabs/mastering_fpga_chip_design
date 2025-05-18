LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std;
library unisim;
use unisim.vcomponents.all;

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
  signal u0_q           : std_logic;
  signal u1_q           : std_logic;
  signal u2_q           : std_logic;
  signal u3_q           : std_logic;
  signal pulse_1hz      : std_logic := '1';

begin

  i0 : IBUF port map( I => clk, O => clk_100m_loc );
  i1 : BUFG port map( I => clk_100m_loc, O => clk_100m_tree );

  u0 : FDSE port map(S =>'0',CE=>pulse_1hz,C=>clk_100m_tree,D=>u3_q,Q=>u0_q);
  u1 : FDRE port map(R =>'0',CE=>pulse_1hz,C=>clk_100m_tree,D=>u0_q,Q=>u1_q);
  u2 : FDRE port map(R =>'0',CE=>pulse_1hz,C=>clk_100m_tree,D=>u1_q,Q=>u2_q);
  u3 : FDRE port map(R =>'0',CE=>pulse_1hz,C=>clk_100m_tree,D=>u2_q,Q=>u3_q);

  j0 : OBUF port map( I => u0_q, O => led(0) );
  j1 : OBUF port map( I => u1_q, O => led(1) );
  j2 : OBUF port map( I => u2_q, O => led(2) );
  j3 : OBUF port map( I => u3_q, O => led(3) );

end rtl;-- top.vhd
