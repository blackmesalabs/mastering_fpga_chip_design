force data_tx 16#00
force data_en 0
force clk 0 5 ns, 1 10 ns -repeat 10 ns
force ck_en 1 10 ns, 0 20 ns -repeat 100 ns
run 1 us
force data_tx 16#A5; force data_en 1; run 10 ns;
force data_tx 16#00; force data_en 0; run 10 ns;
run 16 us;
