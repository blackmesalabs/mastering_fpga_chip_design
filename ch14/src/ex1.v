  wire        my_enable;
  reg         my_enable_p1;
  reg         my_enable_p2;
  reg  [15:0] global_ck_en_a;
  reg         global_ck_en_b;

always @ ( posedge clk ) begin
  my_enable_p1         <= my_enable;
  my_enable_p2         <= my_enable_p1;
  global_ck_en_a[15:0] <= {16{my_enable_p2}};// Manual Reg Duplication
  global_ck_en_b       <= my_enable_p2;      // Automatic Reg Duplication
end
