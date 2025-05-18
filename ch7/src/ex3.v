my_74193 u0_my_74193
(
  .clk     ( clk                     ),
  .reset   ( reset                   ),
  .load_en ( 1'b0                    ),
  .din     ( 4'd0                    ),
  .inc_en  ( inc_en[0] & enable_loc  ),
  .dec_en  ( dec_en[0] & enable_loc  ),
  .dout    ( cnt_loc[3:0]            )
);// my_74193

my_74193 u1_my_74193
(
  .clk     ( clk                     ),
  .reset   ( reset                   ),
  .load_en ( 1'b0                    ),
  .din     ( 4'd0                    ),
  .inc_en  ( inc_en[1] & enable_loc  ),
  .dec_en  ( dec_en[1] & enable_loc  ),
  .dout    ( cnt_loc[7:4]            )
);// my_74193
