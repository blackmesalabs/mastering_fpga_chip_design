use ieee.std_logic_textio.all;
library std ;
use std.textio.all;

process
  file file_ptr : text is out "dump.txt";
  variable text_line : Line;
begin
  wait until ( clk'event and clk = '1' );
    text_line := null;
    write ( text_line, string'("DOUT = "));
    hwrite( text_line, dout );
    writeline ( file_ptr, text_line );
end process;
