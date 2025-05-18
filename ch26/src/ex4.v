always @ ( posedge clk ) begin
  lb_rd_rdy <= 0;
  if ( lb_wr == 1 && lb_addr[31:0] == 32'h00000010 ) begin
    cfg_block_a[7:0] <= lb_wr_d[7:0];
    cfg_block_b[7:0] <= lb_wr_d[15:8];
  end
  if ( lb_rd == 1 && lb_addr[31:0] == 32'h00000010 ) begin
    lb_rd_d   <= { 16'd0, cfg_block_b[7:0], cfg_block_a[7:0] };
    lb_rd_rdy <= 1;
  end
end
