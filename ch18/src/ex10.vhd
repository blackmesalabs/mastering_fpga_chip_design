  signal a : std_logic_vector(7 downto 0);
  a <= X"80";--Is this -128 or +128?

  // False since -128 is not >= 127
  if ( signed(mult_a) >= conv_signed( 127, 8 ) ) then 
