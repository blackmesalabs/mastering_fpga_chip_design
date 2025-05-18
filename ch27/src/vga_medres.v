/* ****************************************************************************
-- (C) Copyright 2025 Kevin Hubbard - All rights reserved.
-- Source file: vga_medres.v                
-- Date:        March 1, 2025
-- Author:      khubbard
-- Description: Artix7 sample design 320x256 RGB 3:3:3 raster controller
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
-- 0.1   03.01.25  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module vga_medres 
(
  input  wire         clk_dot,   
  input  wire         clk_lb,   
  input  wire         lb_wr,   
  input  wire [31:0]  lb_addr, 
  input  wire [31:0]  lb_wr_d, 
  input  wire         lb_cs_medres_ram,

  input  wire         vid_active,
  input  wire [11:0]  x_cnt,     
  input  wire [11:0]  y_cnt,     
  output reg  [11:0]  rgb     
);// module vga_medres


  reg  [8:0]    ram1_array[81_920-1:0];  // 20 36Kb BRAM
  reg  [16:0]   ram1_addr;
  reg  [8:0]    ram1_data;
  reg  [11:0]   y_cnt_p1;


//-----------------------------------------------------------------------------
// Every 4 dot clocks load new RGB[3:3:3] from RAM
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot )
begin
  y_cnt_p1 <= y_cnt[11:0];
  if ( vid_active == 1 && x_cnt[1:0] == 2'd0 ) begin
    rgb       <= { ram1_data[8:6], 1'b0,
                   ram1_data[5:3], 1'b0,
                   ram1_data[2:0], 1'b0  };
    if ( x_cnt[11:0] < 12'd1279 ) begin
      ram1_addr <= ram1_addr[16:0] + 1;// Post-Increment Address
    end
  end
  if ( x_cnt[11:0] == 12'd1279 ) begin
    if ( y_cnt[1:0] != 2'd3 ) begin
      ram1_addr <= ram1_addr[16:0] - 17'd320;
    end
  end

  if ( vid_active == 0 ) begin
    rgb <= 12'd0;
  end
  if ( y_cnt[11:0] == 12'd0 && y_cnt_p1[11:0] != 12'd0 ) begin
    ram1_addr <= 17'd0;
  end
end


//-----------------------------------------------------------------------------
// Dual Port RAM - Infer for text buffer. Writable by local bus
//-----------------------------------------------------------------------------
// Write Ports
always @( posedge clk_lb ) 
begin
  if ( lb_wr == 1 && lb_cs_medres_ram == 1 ) begin
    ram1_array[lb_addr[18:2]] <= { lb_wr_d[10:8], lb_wr_d[6:4], lb_wr_d[2:0] };
  end 
end // always

// Read Ports
always @( posedge clk_dot )
begin
  ram1_data <= ram1_array[ram1_addr];
end // always
  

endmodule // vga_medres.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
