  reg  [15:0] delay_sr;
always @ ( posedge clk ) begin
 if ( reset == 1 ) begin
   delay_sr <= 16'd0;
 end else begin
   delay_sr <= { delay_sr[14:0], din };
 end
end
  assign dout = delay_sr[15];
