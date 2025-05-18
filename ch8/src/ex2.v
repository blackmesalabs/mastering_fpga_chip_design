`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module traffic_light
(
  input  wire       clk,
  input  wire       reset,
  input  wire       pulse_5s,
  output reg        light_green,
  output reg        light_yellow,
  output reg        light_red
);// module traffic_light

  localparam[1:0]
    FSM_ST_ZERO  = 2'h0,
    FSM_ST_ONE   = 2'h1,
    FSM_ST_TWO   = 2'h2,
    FSM_ST_THREE = 2'h3;
  reg [1:0] tl_fsm_st = 2'd0;

always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    tl_fsm_st    <= FSM_ST_ZERO;
    light_green <= 0; light_yellow <= 0; light_red <= 0;
  end else if ( pulse_5s == 1 ) begin
    light_green <= 0; light_yellow <= 0; light_red <= 0;
    case( tl_fsm_st )
      FSM_ST_ZERO  : begin
          tl_fsm_st    <= FSM_ST_ONE;
        end
      FSM_ST_ONE   : begin
          tl_fsm_st    <= FSM_ST_TWO;
          light_green  <= 1;
        end
      FSM_ST_TWO   : begin
          tl_fsm_st    <= FSM_ST_THREE;
          light_yellow <= 1;
        end
      FSM_ST_THREE : begin
          tl_fsm_st    <= FSM_ST_ONE;
          light_red    <= 1;
        end
      default : begin
          tl_fsm_st <= FSM_ST_ZERO;
        end
    endcase // tl_fsm_st
  end
end

endmodule // traffic_light.v
`default_nettype wire // enable Verilog default for 3rd party IP
