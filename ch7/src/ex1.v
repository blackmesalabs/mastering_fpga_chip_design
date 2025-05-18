`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module my_74193
(
  input  wire       clk,
  input  wire       reset,
  input  wire       load_en,
  input  wire       inc_en,
  input  wire       dec_en,
  input  wire [3:0] din,
  output wire [3:0] dout
);// module my_74193

  reg  [3:0]  my_cnt = 4'd0;

always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    my_cnt = 4'd0;
  end else begin
    if ( load_en == 1 ) begin
      my_cnt <= din[3:0];
    end else if ( inc_en == 1 ) begin
      my_cnt <= my_cnt[3:0] + 1;
    end else if ( dec_en == 1 ) begin
      my_cnt <= my_cnt[3:0] - 1;
    end
  end
end
  assign dout = my_cnt[3:0];

endmodule // my_74193.v
`default_nettype wire // enable default for any ext IP needing it
