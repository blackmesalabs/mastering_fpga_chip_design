force clk 0 5 ns, 1 10 ns -repeat 10 ns
force rx_pin 1
force ck_en 1 10 ns, 0 20 ns -repeat 100 ns
run 4 us
force rx_pin 0; run 1600 ns; # Start Bit
force rx_pin 1; run 1600 ns; # D[0]
force rx_pin 0; run 1600 ns; # D[1]
force rx_pin 1; run 1600 ns; # D[2]
force rx_pin 0; run 1600 ns; # D[3]
force rx_pin 0; run 1600 ns; # D[4]
force rx_pin 1; run 1600 ns; # D[5]
force rx_pin 0; run 1600 ns; # D[6]
force rx_pin 1; run 1600 ns; # D[7]
force rx_pin 1; run 1600 ns; # Stop Bit
run 1 us;
