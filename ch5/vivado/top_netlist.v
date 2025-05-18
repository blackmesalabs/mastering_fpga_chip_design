module top
(
  input        clk,
  output [3:0] led
);
  wire c0;
  wire c1;
  wire clk;
  wire clk_IBUF;
  wire clk_t;
  wire [3:0] led;
  wire [3:0] led_O;

  GND GND (.G(c0));
  VCC VCC (.P(c1));
  BUFG clk_t_inst (.I(clk_IBUF), .O(clk_t));
  IBUF clk_IBUF_inst (.I(clk), .O(clk_IBUF));
  FDRE d_flop_sr[0] (.C(clk_t), .CE(c1), .D(led_O[3]), .Q(led_O[0]), .R(c0));
  FDRE d_flop_sr[1] (.C(clk_t), .CE(c1), .D(led_O[0]), .Q(led_O[1]), .R(c0));
  FDRE d_flop_sr[2] (.C(clk_t), .CE(c1), .D(led_O[1]), .Q(led_O[2]), .R(c0));
  FDRE d_flop_sr[3] (.C(clk_t), .CE(c1), .D(led_O[2]), .Q(led_O[3]), .R(c0));
  OBUF led_O[0]_inst (.I(led_O[0]), .O(led[0]));
  OBUF led_O[1]_inst (.I(led_O[1]), .O(led[1]));
  OBUF led_O[2]_inst (.I(led_O[2]), .O(led[2]));
  OBUF led_O[3]_inst (.I(led_O[3]), .O(led[3]));
endmodule
