integer file_ptr;
initial begin
  file_ptr = $fopen("dump.txt", "w" );
end

always @ ( posedge clk ) begin
  $fdisplay(file_ptr,"%S = %01X", "DOUT", dout);
end
