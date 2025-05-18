always @ ( posedge clk ) begin
  if ( reset == 1 ) begin
    cnt <= 8'd0;
  end else begin
    cnt <= cnt[7:0] + 1;
  end
end
