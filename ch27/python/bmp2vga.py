# Convert a BMP file to bd_shell write commands for vga_medres.v module.
import sys;

file_in  = open( sys.argv[1] , "r" );
file_out = open( sys.argv[2] , "w" );

i = 0; j = 0; k = 0; rgb = 0x000; addr = 0x80000;
m = 0; l = 0;
for line in file_in:
  for char in line:
    i+=1; 
    if ( i > 54 ):
      j+=1;
      byte = ord(char);
      byte = byte >> 5;  
      rgb = rgb >> 4;
      rgb = rgb | ( byte << 8 );
      if ( j == 3 ):
        k = k + 1;
        if k == 1:
          txt = "w %05x " % addr;
        txt += "%03x " % rgb;
        if k == 8:
          file_out.write( txt + "\n" );
          txt = "";
          k = 0;
        j = 0; rgb = 0x000; addr += 0x4;

file_in.close();
file_out.close();
