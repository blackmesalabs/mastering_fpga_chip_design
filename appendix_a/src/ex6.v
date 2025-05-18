always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    reset_pre  <= 1;
    reset_sync <= 1;
  end else begin
    reset_pre  <= 0;
    reset_sync <= reset_pre;
  end
end
