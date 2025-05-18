# My Comment : Run the counter coming out of reset
force clk 0 5 ns, 1 10 ns -repeat 10 ns
force reset 1; run 10 ns
force reset 0; run 10 ns
run 100 ns
