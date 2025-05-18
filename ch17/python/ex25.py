import pickle;
import gzip;
# Pickle the data in my_list
pickle_file = gzip.GzipFile("my_list.pkl.gz",'wb');
pickle_file.write( pickle.dumps( my_list , -1));
pickle_file.close();

# UnPickling
pickle_file = gzip.open( "my_list.pkl.gz","rb");
my_list = pickle.load( pickle_file );
pickle_file.close();
