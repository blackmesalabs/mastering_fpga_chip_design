  wire [7:0] a;
  assign a = 8'h80;// Is this -128 or +128?

  // True since +128 is >= +128
  if ( a >= 128 ) begin

  // False since -128 is not >= +128
  if ( $signed(a) >= 128 ) begin
