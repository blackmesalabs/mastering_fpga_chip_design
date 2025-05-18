always @ ( b or c ) begin
  if ( b == 1 && c == 0 ) begin
    a <= 0;
  end else begin
    a <= b;
  end
end
