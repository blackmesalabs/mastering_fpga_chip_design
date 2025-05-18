library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_counter is
end tb_counter;

architecture behav of tb_counter is

component counter
port
(
  reset : in  std_logic;
  clk   : in  std_logic;
  load  : in  std_logic;
  din   : in  std_logic_vector(3 downto 0);
  dout  : out std_logic_vector(3 downto 0)
);
end component;

  signal reset : std_logic;
  signal clk   : std_logic;
  signal load  : std_logic;
  signal din   : std_logic_vector(3 downto 0);
  signal dout  : std_logic_vector(3 downto 0);

begin

process
begin
  clk <= '1'; wait for 5 ns;
  clk <= '0'; wait for 5 ns;
end process;

process
begin
  wait for 1 ns;
  reset <= '1'; load <= '0'; din <= X"0"; wait for 10 ns;
  reset <= '0'; wait for 40 ns;
  load  <= '1'; din <= X"A"; wait for 10 ns;
  load  <= '0'; din <= X"0"; wait for 40 ns;
  assert ( FALSE )
    report ("Simulation Done" )
    severity failure;
end process;

u_counter : counter
port map
(
  reset => reset,
  clk   => clk,
  load  => load,
  din   => din(3 downto 0),
  dout  => dout(3 downto 0)
);

end behav;
