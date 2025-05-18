always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    a <= 0;
  end else begin
    a <= b;
  end
end
