force clk 0 5 ns, 1 10 ns -repeat 10 ns
force reset 1
force load  0
force din   16#0
run 10 ns
force reset 0
run 40 ns
force load 1; force din 16#A; run 10 ns;
force load 0; force din 16#0; run 10 ns;
run 40 ns
