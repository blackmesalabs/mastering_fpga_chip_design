type fsm_state_type is
(
  FSM_ST_ZERO,
  FSM_ST_ONE
);
signal fsm_st : fsm_state_type := FSM_ST_ZERO;

process ( clk, reset )
begin
  if ( reset = '1' ) then
    fsm_st <= FSM_ST_ZERO;
  elsif ( clk'event and clk = '1' ) then
    case fsm_st is 
      when FSM_ST_ZERO =>
        fsm_st <= FSM_ST_ONE;
      when FSM_ST_ONE  =>
        fsm_st <= FSM_ST_ZERO;
      when others =>
        fsm_st <= FSM_ST_ZERO;
      end case;
    end if;
  end if;
end process;
