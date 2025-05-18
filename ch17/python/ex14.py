file_in  = open( file_name, 'r' );
my_list = file_in.readlines();
file_in.close();
my_list = [ each.strip('\n') for each in my_list ];# list comprehension
