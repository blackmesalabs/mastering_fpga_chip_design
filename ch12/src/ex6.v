module top
(
  input  wire reset,   
  input  wire clk_100m
);// module top

  IBUF u0_ibuf ( .I( clk_100m     ), .O( clk_100m_in   ) );
  BUFG u0_bufg ( .I( clk_100m_loc ), .O( clk_100m_tree ) );
  BUFG u1_bufg ( .I( clk_133m_loc ), .O( clk_133m_tree ) );
  BUFG u2_bufg ( .I( clk_160m_loc ), .O( clk_160m_tree ) );

my_pll u0_my_pll
(
 .reset    ( reset        ),
 .pll_lock ( pll_lock     ),
 .clk_ref  ( clk_100m_in  ), // x8 = 800 MHz
 .clk_100m ( clk_100m_loc ), // Div-8 = 100 MHz
 .clk_133m ( clk_133m_loc ), // Div-6 = 133 MHz
 .clk_160m ( clk_160m_loc )  // Div-5 = 160 MHz
);
