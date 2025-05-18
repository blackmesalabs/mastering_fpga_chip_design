u0 : FDSE port map(S=>'0',CE=>pulse_1hz,C=>clk_100m_tree,D=>u3_q,Q=>u0_q);

process ( clk_100m_tree )
begin
  if ( clk_100m_tree'event and clk_100m_tree = '1' ) then
    if ( pulse_1hz = '1' ) then
      u0_q <= u3_q;
    end if;
  end if;
end process;
