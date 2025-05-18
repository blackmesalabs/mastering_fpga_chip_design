def filegz2list( file_name ):
  import gzip;
  list_out = [];
  with gzip.open( file_name, "rt" ) as file_in_gz:
    list_out = [ each.strip('\n').strip('\r') for each in file_in_gz ];
  return list_out;
def list2filegz( file_name, list ):
  import gzip;
  with gzip.open( file_name, "wt" ) as file_out_gz:
    for each in list:
      file_out_gz.write( each+'\n' )
    file_out_gz.close();
  return;
