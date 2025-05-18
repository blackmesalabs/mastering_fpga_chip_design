`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top
(
  input  wire       clk,
  input  wire       reset,
  output reg        led
);// module top

  reg  [2:0]  cnt_en_sr = 3'b000;
  reg         not_all_zero = 0;
  reg         not_all_zero_p1 = 0;
  reg         not_all_zero_p2 = 0;
  reg  [39:0] cnt_a = 0;
  reg  [39:0] cnt_b = 0;
  reg  [39:0] cnt_c = 0;
  reg  [39:0] cnt_a_p1 = 0;
  reg  [39:0] cnt_b_p1 = 0;
  reg  [39:0] cnt_c_p1 = 0;
  wire        clk_333m;
  reg  [2:0]  not_all_zero_pre = 3'd0;

BUFGCE u0_bufg ( .I( clk ), .O( clk_333m ), .CE( 1'b1   ) );

always @ ( posedge clk_333m ) begin
  cnt_en_sr <= { cnt_en_sr[2:0], 1'b1 };
  if ( cnt_en_sr[0] == 1 ) begin
    cnt_a <= cnt_a[39:0] + 1;
  end
  if ( cnt_en_sr[1] == 1 ) begin
    cnt_b <= cnt_b[39:0] + 1;
  end
  if ( cnt_en_sr[2] == 1 ) begin
    cnt_c <= cnt_c[39:0] + 1;
  end
end

always @ ( posedge clk_333m ) begin
  cnt_a_p1 <= cnt_a[39:0];
  cnt_b_p1 <= cnt_b[39:0];
  cnt_c_p1 <= cnt_c[39:0];
end

always @ ( posedge clk_333m ) begin
  if ( cnt_a_p1 != 40'd0 ||
       cnt_b_p1 != 40'd0 ||
       cnt_c_p1 != 40'd0    ) begin
    not_all_zero <= 1;
  end else begin
    not_all_zero <= 0;
  end
end

always @ ( posedge clk_333m ) begin
  not_all_zero_p1 <= not_all_zero;
  not_all_zero_p2 <= not_all_zero_p1;
  led             <= ~ not_all_zero_p2;
end

endmodule // top.v
`default_nettype wire // enable Verilog default for 3rd party IP 
