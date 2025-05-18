# Read in source files
#read_verilog [ glob ../src/*.v ]     # use glob if all .v files in src are desi
#read_vhdl    [ glob ../src/*.vhd ]   # use glob if all .vhd files in src are de
read_verilog ../src/top.v
read_verilog ../src/uart_rx.v
read_verilog ../src/uart_tx.v
