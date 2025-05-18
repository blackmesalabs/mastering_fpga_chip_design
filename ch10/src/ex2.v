`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module ram_36kb_1Kx36_2ck_2w2r #
(
  parameter depth_len  = 1024,
  parameter depth_bits = 10,
  parameter width_bits = 36
)
(
  input  wire                  sleep,
  input  wire                  a_clk,
  input  wire                  b_clk,
  input  wire                  a_en,
  input  wire                  b_en,

  input  wire                  a_we,
  input  wire [depth_bits-1:0] a_addr,
  input  wire [width_bits-1:0] a_di,
  output wire [width_bits-1:0] a_do,

  input  wire                  b_we,
  input  wire [depth_bits-1:0] b_addr,
  input  wire [width_bits-1:0] b_di,
  output wire [width_bits-1:0] b_do
);


// xpm_memory_tdpram: True Dual Port RAM
// Xilinx Parameterized Macro, version 2024.1

xpm_memory_tdpram #(
   .ADDR_WIDTH_A(depth_bits),
   .ADDR_WIDTH_B(depth_bits),
   .AUTO_SLEEP_TIME(0),
   .BYTE_WRITE_WIDTH_A(width_bits),
   .BYTE_WRITE_WIDTH_B(width_bits),
   .CASCADE_HEIGHT(0),
   .CLOCKING_MODE("independent_clock"),
   .ECC_BIT_RANGE("7:0"),
   .ECC_MODE("no_ecc"),
   .ECC_TYPE("none"),
   .IGNORE_INIT_SYNTH(0),
   .MEMORY_INIT_FILE("none"),
   .MEMORY_INIT_PARAM("0"),
   .MEMORY_OPTIMIZATION("true"),
   .MEMORY_PRIMITIVE("auto"),
   .MEMORY_SIZE(depth_len*width_bits),
   .MESSAGE_CONTROL(0),
   .RAM_DECOMP("auto"),
   .READ_DATA_WIDTH_A(width_bits),
   .READ_DATA_WIDTH_B(width_bits),
   .READ_LATENCY_A(2),
   .READ_LATENCY_B(2),
   .READ_RESET_VALUE_A("0"),
   .READ_RESET_VALUE_B("0"),
   .RST_MODE_A("SYNC"),
   .RST_MODE_B("SYNC"),
   .SIM_ASSERT_CHK(0),
   .USE_EMBEDDED_CONSTRAINT(0),
   .USE_MEM_INIT(1),
   .USE_MEM_INIT_MMI(0),
   .WAKEUP_TIME("use_sleep_pin"),
   .WRITE_DATA_WIDTH_A(width_bits),
   .WRITE_DATA_WIDTH_B(width_bits),
   .WRITE_MODE_A("no_change"),
   .WRITE_MODE_B("no_change"),
   .WRITE_PROTECT(1)
)
xpm_memory_tdpram_inst (
   .sleep    ( sleep   ),
   .clka     ( a_clk   ),
   .clkb     ( b_clk   ),
   .ena      ( a_en    ),
   .enb      ( b_en    ),
   .regcea   ( a_en    ),
   .regceb   ( b_en    ),
   .rsta     ( 1'b0    ),
   .rstb     ( 1'b0    ),

   .wea      ( a_we    ),
   .addra    ( a_addr  ),
   .dina     ( a_di    ),
   .douta    ( a_do    ),

   .web      ( b_we    ),
   .addrb    ( b_addr  ),
   .dinb     ( b_di    ),
   .doutb    ( b_do    ),
   .sbiterra (         ),
   .sbiterrb (         ),
   .dbiterra (         ),
   .dbiterrb (         ),
   .injectdbiterra(1'b0),
   .injectdbiterrb(1'b0),
   .injectsbiterra(1'b0),
   .injectsbiterrb(1'b0)
);

// End of xpm_memory_tdpram_inst instantiation

endmodule // ram_36kb_1Kx36_2ck_2w2r
`default_nettype wire // enable default for 3rd party IP needing it
