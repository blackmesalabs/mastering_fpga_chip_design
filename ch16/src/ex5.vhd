process
  file file_in_ptr      : text is in "stimulus.txt";
  variable text_in_line : string(1 to 80);
  variable text2_line   : Line;
  variable line_len     : integer;
  variable parse_word   : string(1 to 80 );
  variable reset_var    : std_logic_vector(3 downto 0);
  variable load_var     : std_logic_vector(3 downto 0);
  variable din_var      : std_logic_vector(3 downto 0);
begin
 while not ( endfile( file_in_ptr ) ) loop
  read( file_in_ptr, text_in_line, line_len );
  wait until ( clk'event and clk = '1' );
    text2_line := null;
    parse_word(1 to 2) := text_in_line(1) & NUL;
    write( text2_line, parse_word );
    hread( text2_line, reset_var );

    text2_line := null;
    parse_word(1 to 2) := text_in_line(3) & NUL;
    write( text2_line, parse_word );
    hread( text2_line, load_var );

    text2_line := null;
    parse_word(1 to 2) := text_in_line(5) & NUL;
    write( text2_line, parse_word );
    hread( text2_line, din_var );

    reset <= reset_var(0);
    load  <= load_var(0);
    din   <= din_var(3 downto 0);
 end loop;
 assert ( FALSE )
   report ("Simulation Done" )
   severity failure;
end process;
