/* ****************************************************************************
-- (C) Copyright 2018 Kevin M. Hubbard - All rights reserved.
-- Source file: pll_7series.v 
-- Date:        May 2018 
-- Author:      khubbard
-- Language:    Verilog-2001
-- Simulation:  Mentor-Modelsim
-- Synthesis:   Xilinx-Vivado
-- License:     This project is licensed with the CERN Open Hardware Licence
--              v1.2.  You may redistribute and modify this project under the
--              terms of the CERN OHL v.1.2. (http://ohwr.org/cernohl).
--              This project is distributed WITHOUT ANY EXPRESS OR IMPLIED
--              WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY
--              AND FITNESS FOR A PARTICULAR PURPOSE. Please see the CERN OHL
--              v.1.2 for applicable Conditions.
-- Description: Xilinx 7-Series XPM inferred dual-clock FIFO.
-- ug472_7Series_Clocking.pdf
--
-- Note: Spartan7 the MMCM VCO frequency range is 600.000 - 1200.000 MHz
-- ************************************************************************* */
`timescale 1 ns/ 100 ps
module pll_7series
(
  input  wire         reset,
  input  wire         clk_ref,
  output wire         pll_lock,
  output wire         clk0_out,
  output wire         clk1_out,
  output wire         clk2_out,
  output wire         clk3_out
);// pll_7series

  wire  clk_fb;
  wire  clk_fb_tree;

// Note : 900 MHz / 8.375 = 107.4627 MHz

// MMCME2_BASE: Base Mixed Mode Clock Manager // 7 Series
MMCME2_BASE #
(
  .BANDWIDTH("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
  .DIVCLK_DIVIDE(1),       // Master division value (1-106)
  .CLKFBOUT_MULT_F( 9.0),  // Multiply value for all CLKOUT 2.000-64.000
  .CLKFBOUT_PHASE(0.0),    // Phase offset in degrees of CLKFB -360.000-360.000
  .CLKIN1_PERIOD(10.0),    // Input clock in ns and ps res (33.333 is 30 MHz)

// Divide amount for each CLKOUT (1-128)
// _F hardware granularity is (0.125)
  .CLKOUT0_DIVIDE_F(8.375), // Divide amount for CLKOUT0 (1.000-128.000).
  .CLKOUT1_DIVIDE( 9),
  .CLKOUT2_DIVIDE( 9),
  .CLKOUT3_DIVIDE( 9),
  .CLKOUT4_DIVIDE(9),
  .CLKOUT5_DIVIDE(9),
  .CLKOUT6_DIVIDE(9),

// Duty cycle for each CLKOUT (0.01-0.99).
  .CLKOUT0_DUTY_CYCLE(0.5),
  .CLKOUT1_DUTY_CYCLE(0.5),
  .CLKOUT2_DUTY_CYCLE(0.5),
  .CLKOUT3_DUTY_CYCLE(0.5),
  .CLKOUT4_DUTY_CYCLE(0.5),
  .CLKOUT5_DUTY_CYCLE(0.5),
  .CLKOUT6_DUTY_CYCLE(0.5),

// Phase offset for each CLKOUT (-360.000-360.000).
  .CLKOUT0_PHASE(0.0),
  .CLKOUT1_PHASE(0.0),
  .CLKOUT2_PHASE(0.0),
  .CLKOUT3_PHASE(90.0),
  .CLKOUT4_PHASE(0.0),
  .CLKOUT5_PHASE(0.0),
  .CLKOUT6_PHASE(0.0),

  .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
  .REF_JITTER1(0.0), // Reference input jitter in UI (0.000-0.999).
  .STARTUP_WAIT("FALSE") // Delays DONE until MMCM is locked (FALSE, TRUE)
)
MMCME2_BASE_inst
(
  // Clock Outputs: 1-bit (each) output: User configurable clock outputs
  .CLKOUT0   (clk0_out),     // 1-bit output: CLKOUT0
  .CLKOUT0B  (        ),     // 1-bit output: Inverted CLKOUT0
  .CLKOUT1   (clk1_out),     // 1-bit output: CLKOUT1
  .CLKOUT1B  (        ),     // 1-bit output: Inverted CLKOUT1
  .CLKOUT2   (clk2_out),     // 1-bit output: CLKOUT2
  .CLKOUT2B  (        ),     // 1-bit output: Inverted CLKOUT2
  .CLKOUT3   (clk3_out),     // 1-bit output: CLKOUT3
  .CLKOUT3B  (        ),     // 1-bit output: Inverted CLKOUT3
  .CLKOUT4   (        ),     // 1-bit output: CLKOUT4
  .CLKOUT5   (        ),     // 1-bit output: CLKOUT5
  .CLKOUT6   (        ),     // 1-bit output: CLKOUT6
  // Feedback Clocks: 1-bit (each) output: Clock feedback ports
  .CLKFBOUT  (clk_fb  ),     // 1-bit output: Feedback clock
  .CLKFBOUTB (         ),    // 1-bit output: Inverted CLKFBOUT
  // Status Ports: 1-bit (each) output: MMCM status ports
  .LOCKED    (pll_lock),     // 1-bit output: LOCK
  // Clock Inputs: 1-bit (each) input: Clock input
  .CLKIN1    (clk_ref),      // 1-bit input: Clock
  // Control Ports: 1-bit (each) input: MMCM control ports
  .PWRDWN    ( 1'b0 ),       // 1-bit input: Power-down
  .RST       ( reset ),      // 1-bit input: Reset
  // Feedback Clocks: 1-bit (each) input: Clock feedback ports
  .CLKFBIN   ( clk_fb_tree ) // 1-bit input: Feedback clock
);
// End of MMCME2_BASE_inst instantiation

 BUFG u0_bufg ( .I( clk_fb ), .O( clk_fb_tree ) );

endmodule
