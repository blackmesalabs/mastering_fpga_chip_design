verilator -Wall --trace -cc tb_top.v top.v --exe tb_top.cpp
make -C obj_dir -f Vtb_top.mk Vtb_top
