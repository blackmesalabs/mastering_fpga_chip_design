module top
(
  input  wire clk_100m   
);// module top

  wire        clk_100m_loc;
  wire        clk_100m_tree;
  reg  [3:0]  my_cnt = 4'd0;

  IBUF u0_ibuf ( .I( clk_100m     ), .O( clk_100m_loc  ) );
  BUFG u0_bufg ( .I( clk_100m_loc ), .O( clk_100m_tree ) );

always @ ( posedge clk_100m_tree ) begin
  my_cnt <= my_cnt[3:0] + 1;
end
