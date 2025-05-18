`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module traffic_light
(
  input  wire       clk,
  input  wire       reset,
  input  wire       pulse_1s,
  input  wire       nmi_emergency_vehicle,
  input  wire       nmi_power_outage,
  output reg        light_green,
  output reg        light_yellow,
  output reg        light_red
);// module traffic_light

  localparam[1:0]
    FSM_ST_RESET   = 2'h0,
    FSM_ST_GREEN   = 2'h1,
    FSM_ST_YELLOW  = 2'h2,
    FSM_ST_RED     = 2'h3;
  reg [1:0] tl_fsm_st = 2'd0;
  reg [3:0] timer_cnt = 4'd0;
  reg       flash_togl = 0;

always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    tl_fsm_st   <= FSM_ST_RESET;
    light_green <= 0; light_yellow <= 0; light_red <= 0;
    timer_cnt   <= 4'd0;
  end else if ( pulse_1s == 1 ) begin
    flash_togl  <= ~ flash_togl;
    light_green <= 0; light_yellow <= 0; light_red <= 0;
    if ( timer_cnt != 4'd0 ) begin
      timer_cnt <= timer_cnt - 1;
    end
    case( tl_fsm_st )
      FSM_ST_RESET : begin
          tl_fsm_st    <= FSM_ST_GREEN;
          timer_cnt    <= 4'd10;
        end
      FSM_ST_GREEN : begin
          light_green  <= 1;
          if ( timer_cnt == 4'd0 ) begin
            tl_fsm_st    <= FSM_ST_YELLOW;
            timer_cnt    <= 4'd5;
          end
          if ( nmi_emergency_vehicle == 1 ) begin
            tl_fsm_st    <= FSM_ST_YELLOW;
            timer_cnt    <= 4'd5;
          end
        end
      FSM_ST_YELLOW : begin
          light_yellow <= 1;
          if ( timer_cnt == 4'd0 ) begin
            tl_fsm_st    <= FSM_ST_RED;
            timer_cnt    <= 4'd15;
          end
        end
      FSM_ST_RED : begin
          if ( nmi_power_outage == 1 ) begin
            light_red    <= flash_togl;
          end else begin
            light_red    <= 1;
          end
          if ( timer_cnt == 4'd0 &
               nmi_emergency_vehicle == 0 &
               nmi_power_outage == 0        ) begin
            tl_fsm_st    <= FSM_ST_GREEN;
            timer_cnt    <= 4'd10;
          end
        end
      default : begin
          tl_fsm_st <= FSM_ST_RESET;
        end
    endcase // tl_fsm_st
  end
end

endmodule // traffic_light.v
`default_nettype wire // enable Verilog default for 3rd party IP
