module top
(
  input  wire clk_100m
);// module top

  reg  [3:0]  my_cnt = 4'd0;

always @ ( posedge clk_100m ) begin
  my_cnt <= my_cnt[3:0] + 1;
end
