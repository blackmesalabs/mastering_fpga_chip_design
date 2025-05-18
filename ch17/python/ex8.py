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
  return input_list;

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
