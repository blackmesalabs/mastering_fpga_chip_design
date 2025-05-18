// Round s5.2 to s5.0
always @(posedge clk) begin
  // Default to rounding down (truncating fractional bits)
  dout_rounded <= cnt[7:2];
  // Is the 0.5 fractional bit set?
  if ( cnt[1] == 1 ) begin
    // If integer is odd, round to nearest even integer      
    if ( cnt[2] == 1 ) begin
      // Don't overflow if already max positive
      if ( cnt[7:2] != 6'b011111 ) begin
        dout_rounded <= cnt[7:2] + 1;
      end
    end
  end
end
