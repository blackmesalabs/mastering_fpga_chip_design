always @ ( posedge clk ) begin
  if ( $time == 70 ) begin
    if ( dout == 4'hA ) begin
      $display("Load Successful!");
    end else begin
      $display("Load Failed!");
      $stop;
    end
  end
end
