/* ****************************************************************************
-- (C) Copyright 2024 Kevin Hubbard - All rights reserved.
-- Source file: uart_tx.v                
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

module uart_tx 
(
  input  wire         clk,   
  input  wire         ck_en, // 16x baud rate
  input  wire         data_en,
  input  wire [7:0]   data_tx,
  output wire         tx_pin 
);// module uart_tx

(* IOB = "true" *) reg tx_iob = 1'b1;// Pragma an IOB Flop
  reg  [3:0]    bit_cnt = 4'h0;
  reg  [3:0]    phs_cnt = 4'h0;
  reg  [9:0]    byte_sr = 10'd0;
  reg           tx_loc  = 1'b1;

  assign tx_pin = tx_iob;

//------------------------------------------------------
// A simple TX only UART 
//------------------------------------------------------
always @ ( posedge clk ) begin 
  tx_iob   <= tx_loc;
  if ( data_en == 1 ) begin
    byte_sr <= { 1'b1, data_tx[7:0], 1'b0 };
    bit_cnt <= 4'd10;
    phs_cnt <= 4'd0;
  end else if ( ck_en == 1 ) begin
    if ( bit_cnt != 4'd0 ) begin
      phs_cnt <= phs_cnt[3:0] + 1;
      if ( phs_cnt == 4'd0 ) begin
        tx_loc  <= byte_sr[0];
        byte_sr <= { 1'b1, byte_sr[9:1] };
        bit_cnt <= bit_cnt[3:0] - 1;
      end
    end
  end
end 


endmodule // uart_tx.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
