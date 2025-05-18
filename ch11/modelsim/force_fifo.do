force reset 1
force clk 0 5 ns, 1 10 ns -repeat 10 ns
force a_push_en 0
force b_pop_en 0
force a_di 16#0
run 10 ns
force reset 0
force a_push_en 1; force a_di 16#1; run 10 ns
force a_push_en 1; force a_di 16#2; run 10 ns
force a_push_en 0; run 10 ns;
force a_push_en 1; force a_di 16#3; run 10 ns
force a_push_en 1; force a_di 16#4; run 10 ns
force b_pop_en 1;
force a_push_en 1; force a_di 16#5; run 10 ns
force a_push_en 1; force a_di 16#6; run 10 ns
force a_push_en 1; force a_di 16#7; run 10 ns
force a_push_en 1; force a_di 16#8; run 10 ns
force a_push_en 0; force a_di 16#0; run 10 ns
force b_pop_en 0; run 10 ns;
force b_pop_en 1; run 30 ns;
force b_pop_en 0; run 10 ns;
run 10 ns;
