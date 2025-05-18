xelab top glbl -prj top.prj -s snapshot -debug typical -initfile=$XILINX_VIVADO/data/xsim/ip/xsim_ip.ini -L work -L xpm -L unisims_ver -L unimacro_ver
xsim snapshot -tclbatch do_files/do.tcl
