/* ****************************************************************************
-- (C) Copyright 2025 Kevin Hubbard - All rights reserved.
-- Source file: vga_text.v                
-- Date:        March 1, 2025
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
-- 0.1   03.01.25  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module vga_text 
(
  input  wire         clk_dot,   
  input  wire         clk_lb,   
  input  wire         lb_wr,   
  input  wire [31:0]  lb_addr, 
  input  wire [31:0]  lb_wr_d, 
  input  wire         lb_cs_text_ram1,
  input  wire         lb_cs_text_ram2,

  input  wire         vid_active,
  input  wire [11:0]  x_cnt,     
  input  wire [11:0]  y_cnt,     
  output reg  [11:0]  rgb     
);// module vga_text


  reg  [11:0]   rom_a_addr = 12'd0;
  reg  [11:0]   rom_b_addr = 12'd0;
  wire [7:0]    rom_a_data;
  wire [7:0]    rom_b_data;
  reg  [7:0]    pel_a_sr;
  reg  [17:0]   ram1_array[4096-1:0];  // 2 36Kb BRAM
  reg  [11:0]   ram1_addr;
  reg  [17:0]   ram1_data;
  reg  [17:0]   ram1_data_p1;
  reg  [17:0]   ram1_data_p2;
  reg  [17:0]   ram1_data_p3;
  reg           ram1_txt_rdy_pre = 0;
  reg           ram1_txt_rdy = 0;
  reg           ram1_txt_rdy_p1 = 0;
  reg           ram1_txt_rdy_p2 = 0;
  reg           ram1_txt_rdy_p3 = 0;
  reg           ping_pong;
  reg  [11:0]   txt_fg_rgb;
  reg  [11:0]   txt_bg_rgb;
  reg  [1:0]    fg_lum;
  reg  [2:0]    fg_rgb;
  reg  [1:0]    bg_lum;
  reg  [2:0]    bg_rgb;


//-----------------------------------------------------------------------------
// Every 16 clocks load X and Y into text RAM addr to get ASCII value and color
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot ) begin : proc_text_x
  ram1_txt_rdy_pre <= 0;
  ram1_txt_rdy     <= ram1_txt_rdy_pre;
  ram1_txt_rdy_p1  <= ram1_txt_rdy;
  ram1_txt_rdy_p2  <= ram1_txt_rdy_p1;
  ram1_txt_rdy_p3  <= ram1_txt_rdy_p2;

  if ( vid_active == 1 && x_cnt[3:0] == 4'd0 ) begin
    ram1_addr[11:0]  <= { y_cnt[9:5], x_cnt[10:4] };
    ram1_txt_rdy_pre <= 1;
  end else begin
    ram1_addr[11:0]  <= 12'd0;
  end
end


//-----------------------------------------------------------------------------
// ASCII value then gets fed into ASCII ROM. 8 bit output of ROM goes into
// 8 bit shift-register that shifts a new pixel out every other dot clock.
// Color is top 10 bits and is packed like this:
// D[17:16] : Foreground Brightness 0-3 ( Luminance or Y )
// D[15:13] : Forground Color RGB Binary
// D[12:11] : Background Brightness 0-3
// D[10:8]  : Background Color RGB Binary
// D[7:0]   : ASCII Text Code
//-----------------------------------------------------------------------------
always @ ( posedge clk_dot ) begin : proc_pel_flops
  rom_a_addr[3:0]  <= y_cnt[4:1];
  rom_a_addr[11:4] <= ram1_data[7:0];

  if ( ram1_txt_rdy_p3 == 1 ) begin
    fg_lum[1:0]   <= ram1_data_p3[17:16];
    fg_rgb[2:0]   <= ram1_data_p3[15:13];
    bg_lum[1:0]   <= ram1_data_p3[12:11];
    bg_rgb[2:0]   <= ram1_data_p3[10:8];
  end

  if ( ram1_txt_rdy_p2 == 1 ) begin
    pel_a_sr[7:0] <= rom_a_data[7:0];
    ping_pong     <= 0;
  end else begin
    ping_pong     <= ~ping_pong;
    if ( ping_pong == 1 ) begin
      pel_a_sr[7:0] <= { pel_a_sr[6:0], 1'b0 };
    end
  end
 
  if ( vid_active == 1 && pel_a_sr[7] == 1 ) begin
//  rgb <= 12'hFFF;
    rgb <= txt_fg_rgb[11:0];
  end else begin
//  rgb <= 12'h000;
    rgb <= txt_bg_rgb[11:0];
  end
end


//-----------------------------------------------------------------------------
// Convert Brightness 0-3 and Binary RGB into 12 bit RGB
//-----------------------------------------------------------------------------
always @ ( * ) begin : proc_color_lut
  txt_fg_rgb[11:8] <= fg_rgb[2] * fg_lum[1:0] * 5;
  txt_fg_rgb[7:4]  <= fg_rgb[1] * fg_lum[1:0] * 5;
  txt_fg_rgb[3:0]  <= fg_rgb[0] * fg_lum[1:0] * 5;
  txt_bg_rgb[11:8] <= bg_rgb[2] * bg_lum[1:0] * 5;
  txt_bg_rgb[7:4]  <= bg_rgb[1] * bg_lum[1:0] * 5;
  txt_bg_rgb[3:0]  <= bg_rgb[0] * bg_lum[1:0] * 5;
end // proc_color_lut


//-----------------------------------------------------------------------------
// Dual Port RAM - Infer for text buffer. Writable by local bus
//-----------------------------------------------------------------------------
// Write Ports
always @( posedge clk_lb )
begin
  if ( lb_wr == 1 && lb_cs_text_ram1 == 1 ) begin
//  ram1_array[ lb_addr[12:2] ] <= lb_wr_d[17:0];
//  ram1_array[ lb_addr[12:2] ] <= {lb_wr_d[20:16],lb_wr_d[12:8],lb_wr_d[7:0]};
    ram1_array[ lb_addr[13:2] ] <= { lb_wr_d[21:20],
                                     lb_wr_d[18:16],
                                     lb_wr_d[12:11],
                                     lb_wr_d[10:8],
                                     lb_wr_d[7:0]    };
  end 
end // always

// Read Ports
always @( posedge clk_dot )
begin
  ram1_data    <= ram1_array[ram1_addr];
  ram1_data_p1 <= ram1_data[17:0];
  ram1_data_p2 <= ram1_data_p1[17:0];
  ram1_data_p3 <= ram1_data_p2[17:0];
end // always
  

//-----------------------------------------------------------------------------
// VGA 8x16 ASCII ROM Font.
//-----------------------------------------------------------------------------
rom_font u_rom_font
(
  .clk         ( clk_dot           ),
  .ck_en       ( 1'b1              ),
  .a_addr      ( rom_a_addr[11:0]  ),
  .a_data      ( rom_a_data[7:0]   ),
//.a_data      (                   ),
  .b_addr      ( rom_b_addr[11:0]  ),
  .b_data      ( rom_b_data[7:0]   )
//.b_data      (                   )
);// u_rom_font    

//assign rom_a_data = 8'h55;
//assign rom_b_data = 8'hAA;

endmodule // vga_text.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
