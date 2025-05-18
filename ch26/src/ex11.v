  reg  [4:0]   cnt_a      = 5'd0;
  reg          pulse_a    = 0;
  reg          pulse_a_jk = 0;
  reg          pulse_b    = 0;
  reg          pulse_clr  = 0;

// Synchronizer stages. See AMD ug901-vivado-synthesis.pdf
(* ASYNC_REG = "TRUE" *) reg          pulse_b_meta   = 0;
(* ASYNC_REG = "TRUE" *) reg  [2:0]   pulse_b_sr     = 3'b000;
(* ASYNC_REG = "TRUE" *) reg          pulse_clr_meta = 0;
(* ASYNC_REG = "TRUE" *) reg  [1:0]   pulse_clr_sr   = 2'b00;
