LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std ;

entity core is
port
(
  clk      : in  std_logic;
  reset    : in  std_logic;
  up_cnt   : out std_logic_vector( 3 downto 0 );
  down_cnt : out std_logic_vector( 3 downto 0 )
);
end core;

architecture rtl of core is

component my_74193
port
(
  clk        :  in std_logic;
  reset      :  in std_logic;
  load_en    :  in std_logic;
  inc_en     :  in std_logic;
  dec_en     :  in std_logic;
  din        :  in std_logic_vector(3 downto 0);
  dout       : out std_logic_vector(3 downto 0)
);
end component ; -- my_74193

  signal enable_sr   : std_logic_vector(2 downto 0) := "000";
  signal enable_loc  : std_logic;
  signal inc_en      : std_logic_vector(1 downto 0) := "01";
  signal dec_en      : std_logic_vector(1 downto 0) := "10";
  signal cnt_loc     : std_logic_vector(7 downto 0);

begin

process ( clk, reset ) 
begin
  if ( reset = '1' ) then
    enable_sr <= "000";
  else
    enable_sr <= enable_sr(1 downto 0) & '1';
  end if;
end process;
  enable_loc <= enable_sr(2);

u0_my_74193 : my_74193
port map
(
  clk        => clk,
  reset      => reset,
  load_en    => '0',
  inc_en     => inc_en(0),
  dec_en     => dec_en(0),
  din        => X"0",     
  dout       => cnt_loc(3 downto 0)
);

u1_my_74193 : my_74193
port map
(
  clk        => clk,
  reset      => reset,
  load_en    => '0',      
  inc_en     => inc_en(1),
  dec_en     => dec_en(1),
  din        => X"0",     
  dout       => cnt_loc(7 downto 4)
);
  up_cnt   <= cnt_loc(3 downto 0);
  down_cnt <= cnt_loc(7 downto 4);

end rtl;-- core.vhd
