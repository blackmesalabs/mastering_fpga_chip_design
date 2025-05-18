module top
(
  input  wire ck_sel,  
  input  wire clk_100m,
  input  wire clk_125m
);// module top

  IBUF u0_ibuf ( .I( clk_100m ), .O( clk_100m_loc ) );
  IBUF u1_ibuf ( .I( clk_125m ), .O( clk_125m_loc ) );

  BUFGMUX u0_bufgmux (  .S( ck_sel        ),
                       .I0( clk_100m_loc  ),
                       .I1( clk_125m_loc  ), 
                        .O( clk_muxd_tree ) );

always @ ( posedge clk_muxd_tree ) begin
  my_cnt <= my_cnt[3:0] + 1;
end
