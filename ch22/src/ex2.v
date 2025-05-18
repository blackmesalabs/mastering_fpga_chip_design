  reg  [15:0] delay_sr;
always @ ( posedge clk ) begin
 delay_sr <= { delay_sr[14:0], din };
 if ( reset == 1 ) begin
   delay_sr[0] <= 0;
 end
end
  assign dout = delay_sr[15];
