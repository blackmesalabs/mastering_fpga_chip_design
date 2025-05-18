  if ( lb_wr == 1 && lb_addr[31:0] == 32'h00000010 ) begin
    cfg_block_a[7:0] <= lb_wr_d[7:0];
  end
  if ( lb_wr == 1 && lb_addr[31:0] == 32'h00000014 ) begin
    cfg_block_b[7:0] <= lb_wr_d[7:0];
  end
