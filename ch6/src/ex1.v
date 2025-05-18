`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top
(
  input  wire       clk,
  output wire [3:0] led
);// module top

  wire        clk_100m_loc;
  wire        clk_100m_tree;
  reg  [3:0]  my_cnt = 4'd0;
  wire        pulse_1hz = 1;

  assign clk_100m_loc = clk;           // infer IBUF
  assign clk_100m_tree = clk_100m_loc; // infer BUFG

always @ ( posedge clk_100m_tree ) begin
  if ( pulse_1hz == 1 ) begin
    my_cnt <= my_cnt[3:0] + 1;
  end
end
  assign led = my_cnt[3:0];

endmodule // top.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
