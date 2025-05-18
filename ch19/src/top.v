`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top
(
  input  wire clk,
  output reg  led
);// module top

  wire          clk_100m_loc;
  wire          clk_100m_tree;
  reg  [26:0]   cnt_1hz = 27'd0;
  reg           led_loc = 0;

  assign clk_100m_loc  = clk; // infer IBUF
  assign clk_100m_tree = clk_100m_loc; // infer BUFG

//-------------------------------------------------------------------
// Flash an LEDs at 1 Hz 
//-------------------------------------------------------------------
always @ ( posedge clk_100m_tree ) begin
  if ( cnt_1hz == 27'd99_999_999 ) begin
    cnt_1hz <= 27'd0;
    led_loc <= ~ led_loc;
  end else begin
    cnt_1hz <= cnt_1hz[26:0] + 1;
  end
  led <= led_loc;
end // proc_led_flops


endmodule // top.v
`default_nettype wire // enable Verilog default for 3rd party IP
