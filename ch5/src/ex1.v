FDSE u0 ( .S(0), .CE(pulse_1hz), .C( clk_100m_tree ), .D( u3_q ), .Q( u0_q ) );

always @ ( posedge clk_100m_tree ) begin
  if ( pulse_1hz == 1 ) begin
    u0_q <= u3_q;
  end
end
