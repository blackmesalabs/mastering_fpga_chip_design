module top
(
  input  wire clk_100m
);// module top

  wire        clk_100m_loc;
  wire        clk_100m_tree;
  wire        clk_25m_loc;
  wire        clk_25m_tree;
  reg  [1:0]  div4_cnt = 2'd0;

  IBUF u0_ibuf ( .I( clk_100m     ), .O( clk_100m_loc  ) );
  BUFG u0_bufg ( .I( clk_100m_loc ), .O( clk_100m_tree ) );
  BUFG u1_bufg ( .I( clk_25m_loc  ), .O( clk_25m_tree  ) );

always @ ( posedge clk_100m_tree ) begin
  div4_cnt    <= div4_cnt[1:0] + 1;
  clk_25m_loc <= div4_cnt[1];
end
