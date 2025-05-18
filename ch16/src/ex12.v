always @ ( posedge clk ) begin
  if ( dout[3:0] == 4'hA ) begin
    `include "inline_a.v"
  end
end
