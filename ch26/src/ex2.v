 reg  foo;
always @ ( posedge clk ) begin
 if ( reset == 1 ) begin
   foo <= 0;
 end else begin
   foo <= bar;
 end
end
