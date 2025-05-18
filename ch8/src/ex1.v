`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module traffic_light
(
  input  wire       clk,
  input  wire       reset,
  input  wire       pulse_5s,
  output wire       light_green,
  output wire       light_yellow,
  output wire       light_red
);// module traffic_light

  reg  [3:0]  tl_fsm_sr = 4'b0001;

always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    tl_fsm_sr <= 4'b0001;
  end else begin
    if ( pulse_5s == 1 ) begin
      tl_fsm_sr <= {tl_fsm_sr[2:1],(tl_fsm_sr[3]|tl_fsm_sr[0]),1'b0};
    end
  end
end
  assign light_green  = tl_fsm_sr[1];
  assign light_yellow = tl_fsm_sr[2];
  assign light_red    = tl_fsm_sr[3];

endmodule // traffic_light.v
`default_nettype wire // enable Verilog default for 3rd party IP
