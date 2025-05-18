  c[8:0] <= {a[7],a[7:0]} + {b[7],b[7:0]};// Sign extend s7 to s8
  if ( c[8:7] == 2'b00 || c[8:7] == 2'b11 ) begin
    overflow_int <= 0;
    d[7:0]       <= c[7:0];// Drop MSB and convert s8 to s7
  end else if ( c[8:7] == 2'b01 ) begin
    overflow_int <= 1;
    d[7:0]       <= 8'h7F;// +127
  end else if ( c[8:7] == 2'b10 ) begin
    overflow_int <= 1;
    d[7:0]       <= 8'h80;// -128
  end  
