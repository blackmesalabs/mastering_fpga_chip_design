FDSE u0 ( .S(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u3_q ), .Q( u0_q ) );
FDRE u1 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u0_q ), .Q( u1_q ) );
FDRE u2 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u1_q ), .Q( u2_q ) );
FDRE u3 ( .R(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u2_q ), .Q( u3_q ) );

  reg [3:0] d_flop_sr = 4'b0001;

always @ ( posedge clk_100m_tree ) begin
  if ( pulse_1hz == 1 ) begin
    d_flop_sr[3:0] <= { d_flop_sr[2:0], d_flop_sr[3] };
  end
end
