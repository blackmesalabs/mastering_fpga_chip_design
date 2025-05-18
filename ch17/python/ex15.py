file_out  = open( file_name, 'w' );
for each in my_list:
  file_out.write( each + "\n" );
file_out.close();
