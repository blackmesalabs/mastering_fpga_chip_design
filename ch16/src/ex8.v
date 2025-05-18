`include "func_check_counting.v"
always @ ( posedge clk ) begin
  dout_p1 <= dout[3:0];
  if ( func_check_counting( dout, dout_p1 ) == 0 ) begin
    $display("Counter stopped counting at T = %d", $time );
  end
end
