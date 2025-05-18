timescale 1 ns/ 100 ps 
`default_nettype none // Strictly enforce all nets to be declared

module top
(
  input  wire       reset,
  input  wire       clk,
  output wire [3:0] led
);// module top

  reg [3:0] my_cnt = 4'd0;

always @ ( posedge clk ) begin
  if ( reset == 1 ) begin
    my_cnt <= 4'd0;
  end else begin
    my_cnt <= my_cnt[3:0] + 1;
  end
end
  assign led = my_cnt[3:0];

endmodule // top.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
