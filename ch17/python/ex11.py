a = 16.1234;
b = "%d %d" % ( a,(a+1) ); # "16 17"
b = "%04x" % ( a );        # "0010"
b = "%0.2f" % ( a );       # "16.12"
b = float("1.234");        # 1.234
b = int("12",10);          # 12
b = int("12",16);          # 18 
b = bin( 0xa );            # "0b1010"
b = hex( 16  );            # "0x10"   

import locale; 
locale.setlocale(locale.LC_ALL,'');
locale.currency(1234.567,grouping=True );# "$1,234.56"
