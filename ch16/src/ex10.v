`include "task_check_counting.v"
always @ ( posedge clk ) begin
  dout_p1 <= dout[3:0];
  task_check_counting( dout, dout_p1 );
end
