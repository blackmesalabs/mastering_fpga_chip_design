/* ****************************************************************************
-- (C) Copyright 2025 Kevin Hubbard - All rights reserved.
-- Source file: vga_sprite.v                
-- Date:        March 9, 2025
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
-- 0.1   03.09.25  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module vga_sprite 
(
  input  wire         clk_dot,   
  input  wire         clk_lb,   
  input  wire         lb_wr,   
  input  wire [31:0]  lb_addr, 
  input  wire [31:0]  lb_wr_d, 
  input  wire         lb_cs_sprite_ram,
  input  wire         lb_cs_sprite_reg,
  input  wire         vid_active,
  input  wire [11:0]  x_cnt,     
  input  wire [11:0]  y_cnt,     
  output reg  [11:0]  rgb     
);// module vga_sprite


  reg  [8:0]    ram_array[4096-1:0];  // 1 36Kb BRAM
  reg  [11:0]   ram_addr;
  reg  [8:0]    ram_data;
  reg  [31:0]   sprite0_reg;
  reg  [10:0]   sprite0_x_pos;
  reg  [9:0]    sprite0_y_pos;
  reg  [3:0]    sprite0_x_size;
  reg  [4:0]    sprite0_y_size;
  reg  [1:0]    sprite0_zoom;
  reg           sprite_x_active_jk;
  reg           sprite_x_active_jk_p1;
  reg           sprite_x_active_jk_p2;
  reg           sprite_y_active_jk;
  reg           sprite_y_active_jk_p1;
  reg           sprite_y_active_jk_p2;
  reg  [11:0]   y_cnt_p1;
  reg  [11:0]   x_cnt_p1;
  reg  [5:0]    x_offset_cnt;
  reg  [5:0]    x_offset_cnt_p1;
  reg  [6:0]    y_offset_cnt;
  reg  [6:0]    y_offset_cnt_p1;


//-----------------------------------------------------------------------------
// Sprite Control Register
//-----------------------------------------------------------------------------
always @( posedge clk_lb )
begin
  if ( lb_wr == 1 && lb_cs_sprite_reg == 1 ) begin
    sprite0_reg <= lb_wr_d[31:0];
  end 
end // always

always @( posedge clk_dot )
begin
  sprite0_x_pos[10:0] <= sprite0_reg[10:0];
  sprite0_y_pos[9:0]  <= sprite0_reg[20:11];
  sprite0_x_size[3:0] <= sprite0_reg[24:21];
  sprite0_y_size[4:0] <= sprite0_reg[29:25];
  sprite0_zoom[1:0]   <= sprite0_reg[31:30];// Reserved
end // always
  

//-----------------------------------------------------------------------------
// Detect Sprite location in raster scan and activate it
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot )
begin 
  y_cnt_p1 <= y_cnt[11:0];
  x_cnt_p1 <= x_cnt[11:0];

  sprite_x_active_jk_p1 <= sprite_x_active_jk;
  sprite_x_active_jk_p2 <= sprite_x_active_jk_p1;
  sprite_y_active_jk_p1 <= sprite_y_active_jk;
  sprite_y_active_jk_p2 <= sprite_y_active_jk_p1;

  if ( x_offset_cnt == 6'd0 && x_offset_cnt_p1 == 6'd1 ) begin
    sprite_x_active_jk <= 0;
  end

  if ( y_offset_cnt == 7'd0 && y_offset_cnt_p1 == 7'd1 ) begin
    sprite_y_active_jk <= 0;
  end

  if ( x_cnt[11:0] == { 1'b0, sprite0_x_pos[10:0] } ) begin
    sprite_x_active_jk <= 1;
  end
  if ( y_cnt[11:0] == { 2'b00, sprite0_y_pos[9:0] } ) begin
    sprite_y_active_jk <= 1;
  end

  if ( y_cnt[11:0] == 12'd0 && y_cnt_p1[11:0] == 12'd0 ) begin
    sprite_x_active_jk <= 0;
    sprite_y_active_jk <= 0;
  end 
end


//-----------------------------------------------------------------------------
// When Sprite is activated, start an x and y countdown. 1/2 pel for 2x size
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot )
begin 
  x_offset_cnt_p1 <= x_offset_cnt[5:0];
  y_offset_cnt_p1 <= y_offset_cnt[6:0];

  if ( sprite_x_active_jk == 1 && sprite_x_active_jk_p1 == 0 &&
       x_offset_cnt == 6'd0 ) begin
    x_offset_cnt[5:0] <= { sprite0_x_size[3:0], 2'b11 };
  end

  if ( sprite_y_active_jk == 1 && sprite_y_active_jk_p1 == 0 &&
       y_offset_cnt == 7'd0 ) begin
    y_offset_cnt[6:0] <= { sprite0_y_size[4:0], 2'b11 };
  end

  if ( x_offset_cnt != 6'd0 ) begin
    x_offset_cnt <= x_offset_cnt[5:0] - 1;// Decrement every dot clock
  end
  if ( y_offset_cnt != 7'd0 && y_cnt[11:0] != y_cnt_p1[11:0] ) begin
    y_offset_cnt <= y_offset_cnt[6:0] - 1;// Decrement every hsync
  end
end


//-----------------------------------------------------------------------------
// When Sprite is active, look up RGB pixel values in RAM.
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot )
begin
  if ( sprite_x_active_jk_p1 == 1 && sprite_y_active_jk_p1 == 1 ) begin
    ram_addr[3:0]  <= sprite0_x_size - x_offset_cnt[5:2];
    ram_addr[8:4]  <= sprite0_y_size - y_offset_cnt[6:2];
    ram_addr[11:9] <= 3'd0;
  end
  rgb <= 12'd0;
  if ( vid_active == 1 && 
       sprite_x_active_jk_p2 == 1 && 
       sprite_y_active_jk_p2 == 1 ) begin
    rgb <= { ram_data[8:6], 1'b0, 
             ram_data[5:3], 1'b0, 
             ram_data[2:0], 1'b0 };
  end
end


//-----------------------------------------------------------------------------
// Dual Port RAM - Infer for text buffer. Writable by local bus
//-----------------------------------------------------------------------------
// Write Ports
always @( posedge clk_lb )
begin
  if ( lb_wr == 1 && lb_cs_sprite_ram == 1 ) begin
    ram_array[ lb_addr[14:2] ] <= { lb_wr_d[10:8], lb_wr_d[6:4], lb_wr_d[2:0] };
  end 
end // always

// Read Ports
always @( posedge clk_dot )
begin
  ram_data    <= ram_array[ram_addr];
end // always
  

endmodule // vga_sprite.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
