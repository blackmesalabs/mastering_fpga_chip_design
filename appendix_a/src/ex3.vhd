component foo
port
(
  clk  : in  std_logic;
  dout : out std_logic
);
end component;-- foo

u_foo : foo
port map
(
  clk  => clk,
  dout => dout
);-- u_foo
