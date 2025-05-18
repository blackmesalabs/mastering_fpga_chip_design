LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std ;

entity traffic_light is
port
(
  clk          : in  std_logic;
  reset        : in  std_logic;
  pulse_5s     : in  std_logic;
  light_green  : out std_logic;
  light_yellow : out std_logic;
  light_red    : out std_logic
);
end traffic_light;

architecture rtl of traffic_light is

  type tl_state_type is
  (
   FSM_ST_ZERO,
   FSM_ST_ONE,
   FSM_ST_TWO,
   FSM_ST_THREE
  );
  signal tl_fsm_st : tl_state_type ;

begin

process ( clk, reset )
begin
  if ( reset = '1' ) then
    tl_fsm_st    <= FSM_ST_ZERO;
    light_green <= '0'; light_yellow <= '0'; light_red <= '0';
  elsif ( clk'event and clk = '1' ) then
    if ( pulse_5s = '1' ) then
      light_green <= '0'; light_yellow <= '0'; light_red <= '0';
      case tl_fsm_st is 
        when FSM_ST_ZERO =>
          tl_fsm_st    <= FSM_ST_ONE;
        when FSM_ST_ONE  =>
          tl_fsm_st    <= FSM_ST_TWO;
          light_green  <= '1';
        when FSM_ST_TWO  =>
          tl_fsm_st    <= FSM_ST_THREE;
          light_yellow <= '1';
        when FSM_ST_THREE  =>
          tl_fsm_st    <= FSM_ST_ONE;
          light_red    <= '1';
        when others =>
          tl_fsm_st    <= FSM_ST_ZERO;
      end case;
    end if;
  end if;
end process;
end rtl;-- traffic_light.vhd
