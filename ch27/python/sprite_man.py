# 
import sys;

color_dict = { 'R' : '700',  # Red
               'G' : '070',  # Green
               'B' : '007',  # Blue
               'Y' : '770',  # Yellow
               'C' : '077',  # Cyan
               'P' : '707',  # Purple
               'p' : '756',  # Pink
               'W' : '777',  # White
               ' ' : '000',  # Black
               '-' : '000',  # Black
             };

file_in  = open( sys.argv[1] , "r" );
file_out = open( sys.argv[2] , "w" );

addr = 0x30000;
for each_line in file_in:
  txt = "w %08x " % addr;
  for char in each_line.rstrip():
    txt += color_dict[char] + " ";
  addr += 0x40;
  file_out.write( txt + "\r\n" );

file_in.close();
file_out.close();
