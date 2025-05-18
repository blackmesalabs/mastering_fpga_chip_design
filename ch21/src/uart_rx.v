/* ****************************************************************************
-- (C) Copyright 2024 Kevin Hubbard - All rights reserved.
-- Source file: uart_rx.v                
-- Date:        November 17, 2024     
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
-- 0.1   11.17.24  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module uart_rx 
(
  input  wire         clk,   
  input  wire         ck_en, // 16x baud rate
  input  wire         rx_pin, 
  output reg          data_rdy,
  output wire [7:0]   data_rx 
);// module uart_rx

(* IOB = "true" *) reg rx_meta = 1'b1;// Pragma an IOB Flop
  reg  [1:0]    rx_sync = 2'd3;// Idle is 1
  reg  [1:0]    rx_sr   = 2'd3;// Idle is 1
  reg  [3:0]    bit_cnt = 4'hF;
  reg  [3:0]    phs_cnt = 4'h0;
  reg  [9:0]    byte_sr = 10'd0;

//------------------------------------------------------
// A simple RX only UART 
//------------------------------------------------------
always @ ( posedge clk ) begin 
  rx_meta  <= rx_pin;
  rx_sync  <= { rx_sync[0], rx_meta };// Two sync stages
  data_rdy <= 0;
  if ( ck_en == 1 ) begin
    rx_sr <= { rx_sr[0], rx_sync[1]};
    if ( bit_cnt == 4'hF ) begin
      if ( rx_sr[1:0] == 2'b10 ) begin
        bit_cnt <= 4'h0;// Start Bit
        phs_cnt <= 4'h9;
      end
    end else begin
      phs_cnt <= phs_cnt[3:0] + 1;
      if ( phs_cnt[3:0] == 4'h0 ) begin
        byte_sr <= { rx_sr[1], byte_sr[9:1] };
        bit_cnt <= bit_cnt[3:0] + 1;
        if ( bit_cnt == 4'd9 ) begin
          bit_cnt  <= 4'hF;// Stop Bit
          data_rdy <= 1;
        end
      end
    end
  end
end 
  assign data_rx = byte_sr[8:1];


endmodule // uart_rx.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
