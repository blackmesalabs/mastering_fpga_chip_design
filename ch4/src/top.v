`timescale 1 ns/ 100 ps

module top
(
  input  wire       clk,
  output wire [3:0] led
);// module top

  wire clk_100m_loc;
  wire clk_100m_tree;
  wire u0_q;
  wire u1_q;
  wire u2_q;
  wire u3_q;
  wire pulse_1hz = 1;

  IBUF i0 ( .I( clk          ), .O( clk_100m_loc  ) );
  BUFG i1 ( .I( clk_100m_loc ), .O( clk_100m_tree ) );

  FDSE u0 ( .S(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u3_q ), .Q( u0_q ));
  FDRE u1 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u0_q ), .Q( u1_q ));
  FDRE u2 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u1_q ), .Q( u2_q ));
  FDRE u3 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u2_q ), .Q( u3_q ));

  OBUF j0 ( .I( u0_q ), .O( led[0] ) );
  OBUF j1 ( .I( u1_q ), .O( led[1] ) );
  OBUF j2 ( .I( u2_q ), .O( led[2] ) );
  OBUF j3 ( .I( u3_q ), .O( led[3] ) );

endmodule // top.v
