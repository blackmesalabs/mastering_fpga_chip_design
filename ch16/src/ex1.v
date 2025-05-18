`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module counter
(
  input  wire       reset,
  input  wire       clk,
  input  wire       load,
  input  wire [3:0] din,
  output wire [3:0] dout
);// module counter

  reg  [3:0]  my_cnt = 4'd0;

always @ ( posedge clk ) begin
  if ( reset == 1 ) begin
    my_cnt <= 4'd0;
  end else if ( load == 1 ) begin
    my_cnt <= din[3:0];
  end else begin
    my_cnt <= my_cnt[3:0] + 1;
  end
end
  assign dout = my_cnt[3:0];

endmodule // counter.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
