create_clock -add -name clk_pin     -period 10.00 -waveform {0 5} [get_ports clk]
#create_clock -period 10.000 -name clk_100m -waveform {0.000 5.000} [get_ports clk_100m_loc]
#create_clock -period  9.300 -name clk_108m -waveform {0.000 4.650} [get_ports clk_108m_loc]
set_input_jitter clk_100m 0.200

# Add clock margin
#set_clock_uncertainty -setup 0.050 [get_clocks clk0_tree]; 
#set_clock_uncertainty -hold  0.050 [get_clocks clk0_tree];
#
#set_clock_uncertainty -setup 0.050 [get_clocks clk1_tree]; 
#set_clock_uncertainty -hold  0.050 [get_clocks clk1_tree];
#
set_clock_groups -asynchronous \
  -group [ get_clocks {clk_pin     }    ] \
  -group [ get_clocks {clk_108m_loc}    ] 

