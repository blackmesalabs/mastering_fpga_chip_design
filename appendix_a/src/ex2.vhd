library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity foo is
port
(
  clk  : in  std_logic;
  bar  : out std_logic_vector(3 downto 0)
);
end foo;

architecture rtl of foo is
  signal abc : std_logic := '0';
begin
end rtl;-- foo.vhd
