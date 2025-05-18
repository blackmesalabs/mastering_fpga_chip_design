set design_name top
set device xc7a35tcpg236-1
set_part $device

# Read in source files
source top_rtl_list.tcl

# Synthesize, Place and Route the design
read_xdc ./${design_name}_timing.xdc
synth_design -top $design_name -part $device
read_xdc ./${design_name}_physical.xdc
place_design
route_design
write_checkpoint -force routed_design

# Report
set  rep_dir ./reports
file mkdir $rep_dir
check_timing -file $rep_dir/post_route_timing_check.rpt
report_timing_summary -file $rep_dir/post_route_timing_summary.rpt
report_clock_utilization -file $rep_dir/post_route_clock_util.rpt
report_utilization -file $rep_dir/post_route_util.rpt
report_io  -file $rep_dir/post_route_io.rpt

# Make bitstream file
write_bitstream -force ${design_name}.bit
write_verilog -force ${design_name}_netlist.v
exit
