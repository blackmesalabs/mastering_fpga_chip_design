import sys;

def main():
  args = sys.argv + [None]*3; # args[0] is this scripts name
  input_file  = args[1];# 1st CLI Argument, ie "foo.txt"
  output_file = args[2];# 2nd CLI Argument, ie "bar.txt"
  input_list = file2list( input_file );
  output_list = some_filter( input_list );
  list2file( output_file, output_list );
  return;

def some_filter( input_list ):
  output_list = [];
  header_list = [];
  footer_list = [];
  header_list += ["library ieee;"];
  header_list += ["use ieee.std_logic_1164.all;"];
  header_list += ["use ieee.std_logic_arith.all;"];
  header_list += ["use ieee.std_logic_unsigned.all;"];

  header_list += ["entity rom_font is"];
  header_list += ["port"];
  header_list += ["("];
  header_list += ["  clk  : in std_logic;"];
  header_list += ["  addr : in std_logic_vector(11 downto 0);"];
  header_list += ["  data : out std_logic_vector(7 downto 0)"];
  header_list += [");"];
  header_list += ["end rom_font;"];
  header_list += ["architecture rtl of rom_font is"];
  header_list += ["type rom_type is array (0 to 4095) of std_logic_vector(7 downto 0);"];
  header_list += [" constant rom : rom_type := ("];

  footer_list += [" );"];
  footer_list += ["begin"];
  footer_list += ["flop_proc : process ( clk )"];
  footer_list += ["begin"];
  footer_list += [" if ( clk'event and clk = '1' ) then"];
  footer_list += ["  data <= rom( conv_integer( addr ) );"];
  footer_list += [" end if;"];
  footer_list += ["end process flop_proc;"];
  footer_list += ["end rtl;"];

  output_list += header_list;

  for txt in input_list:
    if "--" not in txt:
      txt = txt.replace(" ","0");
      txt = txt.replace("#","1");
      output_list += [ '  "'+txt+'",' ];
    else:
      output_list += [ txt ];
  # Remove last comma to make VHDL compatible
  line = output_list[-1];
  line = line.replace(",","");
  output_list[-1] = line;

  output_list += footer_list;
  return output_list;

def file2list( file_name ):
  file_in  = open( file_name, 'r' );
  my_list = file_in.readlines();
  file_in.close();
  my_list = [ each.strip('\n') for each in my_list ];# list comprehension
  return my_list;

def list2file( file_name, my_list ):
  file_out  = open( file_name, 'w' );
  for each in my_list:
    file_out.write( each + "\n" );
  file_out.close();
  return;

try:
  if __name__=='__main__': main()
except KeyboardInterrupt:
  print 'Break!'
