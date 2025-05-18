/* ****************************************************************************
-- (C) Copyright 2024 Kevin Hubbard - All rights reserved.
-- Source file: top.v                
-- Date:        June 2024     
-- Author:      khubbard
-- Description: Artix7 sample design
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
--
-- Revision History:
-- Ver#  When      Who      What
-- ----  --------  -------- ---------------------------------------------------
-- 0.1   05.09.24  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top 
(
  input  wire         clk,   
  input  wire         bd_rx, 
  output wire         bd_tx, 
  input  wire [7:0]   sw,  
  output reg  [7:0]   led
);// module top

  wire          reset_loc;
  wire          clk_100m_loc;
  wire          clk_100m_tree;
  reg  [2:0]    ck_div_cnt = 3'd0;
  reg           ck_en = 0;
  wire [7:0]    data_rx;
  wire          data_rdy;

  assign clk_100m_loc = clk; // infer IBUF
  assign bd_tx = bd_rx;// Wire loopback

  BUFGCE u0_bufg ( .I( clk_100m_loc    ), .O( clk_100m_tree ), .CE(1) );


//-----------------------------------------------------------------------------
// Flash the two LEDs at about 1 Hz because that is what FPGAs and uPs do best
//-----------------------------------------------------------------------------
always @ ( posedge clk_100m_tree ) begin : proc_led_flops
  if ( ck_div_cnt == 3'd6 ) begin
    ck_en      <= 1;
    ck_div_cnt <= 3'd0;
  end else begin
    ck_en      <= 0;
    ck_div_cnt <= ck_div_cnt[2:0] + 1;
  end
  if ( data_rdy == 1 ) begin
    led <= data_rx[7:0];
  end
end // proc_led_flops

uart_rx u_uart_rx
(
  .clk      ( clk_100m_tree    ),
  .ck_en    ( ck_en            ), 
  .rx_pin   ( bd_rx            ),
  .data_rdy ( data_rdy         ),
  .data_rx  ( data_rx[7:0]     )
);// module uart_rx


endmodule // top.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
