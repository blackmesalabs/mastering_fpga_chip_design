  wire [7:0]  a;
  wire [7:0]  b;
  wire [15:0] c;
  wire [7:0]  d;

  c <= a * b;
  d <= c[15:8];
