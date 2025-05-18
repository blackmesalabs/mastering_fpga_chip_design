 reg  [3:0]   reset_sr = 4'd0;
 wire         reset_global;

always @ ( posedge clk or posedge reset ) begin
 if ( reset == 1 ) begin
   reset_sr <= 4'b0000;
 end else begin
   reset_sr <= { reset_sr[2:0], 1'b1 };
 end
end
  assign reset_global = ~ reset_sr[3];
