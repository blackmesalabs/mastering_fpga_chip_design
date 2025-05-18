  stay_red   <= nmi_emergency_vehicle | nmi_power_outage;
  timer_zero <= ( timer_cnt[3:1] == 3'd0 ) ? 1 : 0;

  case( tl_fsm_st[1:0] )
     FSM_ST_RED : begin
          if ( timer_zero == 1 &
               stay_red   == 0   ) begin
            tl_fsm_st[1:0] <= FSM_ST_GREEN;
            timer_cnt[3:0] <= 4'd10;
            timer_zero     <= 0;
          end
        end
