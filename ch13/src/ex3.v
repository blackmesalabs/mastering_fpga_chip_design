  case( tl_fsm_st[1:0] )
     FSM_ST_RED : begin
          if ( timer_cnt == 4'd0 &
               nmi_emergency_vehicle == 0 &
               nmi_power_outage == 0        ) begin
            tl_fsm_st[1:0] <= FSM_ST_GREEN;
            timer_cnt[3:0] <= 4'd10;
          end
        end
