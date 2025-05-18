import os;
os.system("cp foo.txt bar.txt");
import glob;
for each_file in glob.glob("*.txt");
os.chdir("/home");
os.getcwd(); # Current Working Directory
foo = os.listdir( os.getcwd() );  # foo is all files and dirs
foo = "/home/khubbard/foo.txt";
os.path.basename( foo );    # foo.txt
os.path.dirname( foo );     # /home/khubbard'
os.path.split( foo );       # ('/home/khubbard','foo.txt')
os.path.splitdrive( foo );  # ( "C:", "directory" ) on DOS machines
os.path.splitext( foo );    # ('/home/khubbard/foo', '.txt')
os.path.abspath("../../");  # Converts relative to hard path 
os.path.exists( foo );      # True
os.path.isdir( foo );       # False
os.path.join( "/home/khubbard/", "foo.txt" );
for ( root, dirs, files ) in os.walk( str(os.getcwd) ):
  print( str(root)+" "+str(dirs)+" "+str(files));# Walk tree
os.rename("foo.txt","bar.txt");
