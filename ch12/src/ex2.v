module top
(
  input  wire clk_100m_p,
  input  wire clk_100m_n
);// module top

  IBUF u0_ibufds (.I(clk_100m_p), .IB(clk_100m_n), .O(clk_100m_loc));
  BUFG u0_bufg   (.I( clk_100m_loc), .O( clk_100m_tree ));
