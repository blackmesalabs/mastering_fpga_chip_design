//-------------------------------------------------------------------
// Flash an LED at 0.8 Hz 
//-------------------------------------------------------------------
always @ ( posedge clk_100m_tree ) begin
  cnt_1hz <= cnt_1hz[26:0] + 1;
  cnt_msb <= cnt_1hz[26];
  if ( cnt_msb != cnt_1hz[26] ) begin
    led_loc <= ~ led_loc;
  end
  led <= led_loc;
end // proc_led_flops
