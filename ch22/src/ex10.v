always @ ( posedge clk ) begin
  u0_lb_rd_rdy <= 0;
  if ( lb_rd == 1 && lb_addr[31:0] == 32'h00000004 ) begin
    u0_lb_rd_rdy <= 1;
    u0_lb_rd_d   <= 32'h12345678;
  end
end
