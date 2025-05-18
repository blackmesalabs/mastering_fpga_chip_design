/* ****************************************************************************
-- (C) Copyright 2025 Kevin Hubbard - All rights reserved.
-- Source file: top.v                
-- Date:        February 16, 2025
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
-- 0.1   02.16.25  khubbard Creation
-- ***************************************************************************/
`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top 
(
  input  wire         clk,   
  input  wire         bd_rx,     
  output wire         bd_tx,
  output reg  [7:0]   led,
  output reg          Hsync,
  output reg          Vsync,
  output reg  [3:0]   vgaRed,
  output reg  [3:0]   vgaBlue,
  output reg  [3:0]   vgaGreen
);// module top


  reg           reset_loc = 1;
  wire          pll_lock;
  wire          clk_100m_ref;
  wire          clk_100m_loc;
  wire          clk_100m_tree;
  wire          clk_108m_loc;
  wire          clk_108m_tree;
  reg  [8:0]    div500_cnt = 9'd0;
  reg           div500_togl = 0;
  reg  [31:0]   led_cnt;
  wire          lb_wr;
  wire          lb_rd;
  wire [31:0]   lb_addr;
  wire [31:0]   lb_wr_d;
  wire [31:0]   lb_rd_d;
  wire          lb_rd_rdy;
  wire          ftdi_wi;
  wire          ftdi_ro;
  wire          sump3_lb_cs_ctrl;
  wire          sump3_lb_cs_data;
  wire [15:0]   sumpd_events;
  wire          vid_new_frame;
  wire          vid_new_line;
  wire          vid_active;
  wire          vga_hsync;
  wire          vga_vsync;
  reg  [3:0]    vga_red;
  reg  [3:0]    vga_grn;
  reg  [3:0]    vga_blu;
  reg  [11:0]   y_cnt;
  reg  [11:0]   x_cnt;
  wire [11:0]   vga_text_rgb;
  wire [11:0]   vga_medres_rgb;
  wire [11:0]   vga_sprite_rgb;
  wire          lb_cs_text_ram1;
  wire          lb_cs_text_ram2;
  wire          lb_cs_medres_ram;
  wire          lb_cs_sprite_ram;
  wire          lb_cs_sprite_reg;

  assign clk_100m_ref = clk; // infer IBUF

//BUFGCE u0_bufg ( .I( clk_100m_loc ), .O( clk_100m_tree ), .CE(1) );
  BUFGCE u0_bufg ( .I( clk_100m_ref ), .O( clk_100m_tree ), .CE(1) );
  BUFGCE u1_bufg ( .I( clk_108m_loc ), .O( clk_108m_tree ), .CE(1) );

  assign ftdi_wi     = bd_rx;
  assign bd_tx       = ftdi_ro;


//-----------------------------------------------------------------------------
// Infer IOB Flops     
//-----------------------------------------------------------------------------
always @ ( posedge clk_108m_tree ) begin : proc_iob_flops
  Hsync    <= vga_hsync;
  Vsync    <= vga_vsync;
  vgaRed   <= vga_red[3:0] | vga_text_rgb[11:8] | vga_medres_rgb[11:8] | vga_sprite_rgb[11:8];
  vgaGreen <= vga_grn[3:0] | vga_text_rgb[7:4]  | vga_medres_rgb[7:4]  | vga_sprite_rgb[7:4];
  vgaBlue  <= vga_blu[3:0] | vga_text_rgb[3:0]  | vga_medres_rgb[3:0]  | vga_sprite_rgb[3:0];
end


//-----------------------------------------------------------------------------
// Configuration reset
//-----------------------------------------------------------------------------
always @ ( posedge clk_100m_tree ) begin : proc_reset
  reset_loc <= 0;
end


//-----------------------------------------------------------------------------
// Use 7-Series to multiply 100 MHz reference up to 900 MHz and then divide
// it by 8.3333 to get close to 108 MHz dot clock of VGA 1280x1024
//-----------------------------------------------------------------------------
pll_7series u_pll_7series
(
  .reset       ( reset_loc       ),
  .clk_ref     ( clk_100m_ref    ),
  .pll_lock    ( pll_lock        ),
  .clk0_out    ( clk_108m_loc    ),
  .clk1_out    (                 ),
  .clk2_out    (                 ),
  .clk3_out    (                 )
);// u_pll_7series


//-----------------------------------------------------------------------------
// For measurement, make 108 kHz from 108 MHz by dividing by 500 and toggling
//-----------------------------------------------------------------------------
always @ ( posedge clk_108m_tree ) begin : proc_ck_div500
  if ( div500_cnt == 9'd499 ) begin
    div500_cnt  <= 9'd0;
    div500_togl <= ~div500_togl;
  end else begin
    div500_cnt <= div500_cnt[8:0] + 1;
  end
end


// ----------------------------------------------------------------------------
// VGA Timing Generator
// ----------------------------------------------------------------------------
vga_timing u_vga_timing
(
  .reset                           ( ~pll_lock          ),
  .clk_dot                         ( clk_108m_tree      ),
  .vid_new_frame                   ( vid_new_frame      ),
  .vid_new_line                    ( vid_new_line       ),
  .vid_active                      ( vid_active         ),
  .vga_hsync                       ( vga_hsync          ),
  .vga_vsync                       ( vga_vsync          )
);


// ----------------------------------------------------------------------------
// RAM Bank address decoding
// ----------------------------------------------------------------------------
  assign lb_cs_text_ram1  = ( lb_addr[19:16] == 4'h1 ) ? 1 : 0;
  assign lb_cs_text_ram2  = ( lb_addr[19:16] == 4'h2 ) ? 1 : 0;
  assign lb_cs_sprite_ram = ( lb_addr[19:16] == 4'h3 ) ? 1 : 0;
  assign lb_cs_medres_ram = ( lb_addr[19]    == 1'b1 ) ? 1 : 0;

  assign lb_cs_sprite_reg = ( lb_addr[19:0] == 20'h00020 ) ? 1 : 0;


// ----------------------------------------------------------------------------
// VGA Text Generator
// ----------------------------------------------------------------------------
vga_text u_vga_text
(
  .clk_dot                         ( clk_108m_tree      ),
  .clk_lb                          ( clk_100m_tree      ),
  .lb_wr                           ( lb_wr              ),
  .lb_wr_d                         ( lb_wr_d[31:0]      ),
  .lb_addr                         ( lb_addr[31:0]      ),
  .lb_cs_text_ram1                 ( lb_cs_text_ram1    ),
  .lb_cs_text_ram2                 ( lb_cs_text_ram2    ),
  .vid_active                      ( vid_active         ),
  .x_cnt                           ( x_cnt[11:0]        ),
  .y_cnt                           ( y_cnt[11:0]        ),
  .rgb                             ( vga_text_rgb[11:0] )
);


// ----------------------------------------------------------------------------
// VGA Medium Resolution Frame Buffer
// ----------------------------------------------------------------------------
vga_medres u_vga_medres
(
  .clk_dot                         ( clk_108m_tree        ),
  .clk_lb                          ( clk_100m_tree        ),
  .lb_wr                           ( lb_wr                ),
  .lb_wr_d                         ( lb_wr_d[31:0]        ),
  .lb_addr                         ( lb_addr[31:0]        ),
  .lb_cs_medres_ram                ( lb_cs_medres_ram     ),
  .vid_active                      ( vid_active           ),
  .x_cnt                           ( x_cnt[11:0]          ),
  .y_cnt                           ( y_cnt[11:0]          ),
  .rgb                             ( vga_medres_rgb[11:0] )
);


// ----------------------------------------------------------------------------
// VGA Medium Resolution Frame Buffer
// ----------------------------------------------------------------------------
vga_sprite u_vga_sprite
(
  .clk_dot                         ( clk_108m_tree        ),
  .clk_lb                          ( clk_100m_tree        ),
  .lb_wr                           ( lb_wr                ),
  .lb_wr_d                         ( lb_wr_d[31:0]        ),
  .lb_addr                         ( lb_addr[31:0]        ),
  .lb_cs_sprite_ram                ( lb_cs_sprite_ram     ),
  .lb_cs_sprite_reg                ( lb_cs_sprite_reg     ),
  .vid_active                      ( vid_active           ),
  .x_cnt                           ( x_cnt[11:0]          ),
  .y_cnt                           ( y_cnt[11:0]          ),
  .rgb                             ( vga_sprite_rgb[11:0] )
);


//-----------------------------------------------------------------------------
// Count the Vertical and Horizontal position
//-----------------------------------------------------------------------------
always @ ( posedge clk_108m_tree ) begin : proc_cnt_xy 
  if ( vid_new_frame == 1 ) begin
    y_cnt <= 12'h000;
  end else if ( vid_new_line == 1 ) begin
    y_cnt <= y_cnt + 1;
  end
  if ( vid_new_line == 1 ) begin
    x_cnt <= 12'd0;
  end else begin
    x_cnt <= x_cnt + 1;
  end
end // proc_cnt_xy


//-----------------------------------------------------------------------------
// Count the Vertical and Horizontal position
//-----------------------------------------------------------------------------
always @ ( posedge clk_108m_tree ) begin : proc_draw
  vga_red <= 4'd0;
  vga_grn <= 4'd0;
  vga_blu <= 4'd0;

  if ( x_cnt <  12'd3    || 
       x_cnt >  12'd1276     ) begin  
    vga_red <= 4'd15;
    vga_grn <= 4'd15;
    vga_blu <= 4'd15;
  end
  if ( y_cnt <  12'd3    ||
       y_cnt >  12'd1020     ) begin  
    vga_red <= 4'd15;
    vga_grn <= 4'd15;
    vga_blu <= 4'd15;
  end
  if ( y_cnt == x_cnt     ||
       y_cnt == x_cnt + 1 ||
       y_cnt == x_cnt - 1    ) begin
    vga_grn <= 4'd15;
  end

  if ( 1 == 0 ) begin
    if ( y_cnt >  12'd100 && y_cnt < 12'd400 &&
         x_cnt >= 12'd512 && x_cnt <= 12'd1024  ) begin
      if          ( x_cnt[8:7] == 2'd0 ) begin
        vga_red <= x_cnt[6:3];
      end else if ( x_cnt[8:7] == 2'd1 ) begin
        vga_grn <= x_cnt[6:3];
      end else if ( x_cnt[8:7] == 2'd2 ) begin
        vga_blu <= x_cnt[6:3];
      end else if ( x_cnt[8:7] == 2'd3 ) begin
        vga_red <= x_cnt[6:3];
        vga_grn <= x_cnt[6:3];
        vga_blu <= x_cnt[6:3];
      end
    end
  end

  if ( 1 == 0 ) begin
    if ( y_cnt >  12'd600 && y_cnt < 12'd900 &&
         x_cnt >= 12'd512 && x_cnt <= 12'd1024  ) begin
      if          ( x_cnt[8:6] == 3'd0 ) begin
        vga_red <= 4'd0;
        vga_grn <= 4'd0;
        vga_blu <= 4'd0;
      end else if ( x_cnt[8:6] == 3'd1 ) begin
        vga_red[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd2 ) begin
        vga_red[3:0] <= { x_cnt[5:2] };
        vga_grn[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd3 ) begin
        vga_red[3:0] <= { x_cnt[5:2] };
        vga_blu[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd4 ) begin
        vga_grn[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd5 ) begin
        vga_grn[3:0] <= { x_cnt[5:2] };
        vga_blu[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd6 ) begin
        vga_blu[3:0] <= { x_cnt[5:2] };
      end else if ( x_cnt[8:6] == 3'd7 ) begin
        vga_red[3:0] <= { x_cnt[5:2] };
        vga_grn[3:0] <= { x_cnt[5:2] };
        vga_blu[3:0] <= { x_cnt[5:2] };
      end
    end
  end

//vga_red <= 4'd0;
//vga_grn <= 4'd0;
//vga_blu <= 4'd0;

  if ( vid_active == 0 ) begin
    vga_red <= 4'd0;
    vga_grn <= 4'd0;
    vga_blu <= 4'd0;
  end
end // proc_draw


//-----------------------------------------------------------------------------
// Flash LEDs from a binary counter
//-----------------------------------------------------------------------------
always @ ( posedge clk_108m_tree ) begin : proc_led_flops
  led_cnt  <= led_cnt[31:0] + 1;
  led[7:0] <= led_cnt[31:24];
  if ( reset_loc == 1 ) begin
    led_cnt <= 32'd0;
  end
end // proc_led_flops

  assign sumpd_events[ 0]    = div500_togl;
  assign sumpd_events[7:1]   = 7'd0;
  assign sumpd_events[ 8]    = vid_new_frame;
  assign sumpd_events[ 9]    = vid_new_line;
  assign sumpd_events[10]    = vga_red[3];   
  assign sumpd_events[11]    = vga_grn[3];   
  assign sumpd_events[12]    = vga_blu[3];   
  assign sumpd_events[15:13] = 3'd0;


//-----------------------------------------------------------------------------
// MesaBus interface to LocalBus : 2-wire FTDI UART to 32bit PCIe like localbus
// Files available at https://github.com/blackmesalabs/MesaBusProtocol
//   ft232_xface.v, mesa_uart_phy.v, mesa_decode.v, mesa2lb.v, mesa_id.v,
//   mesa2ctrl.v, mesa_uart.v, mesa_tx_uart.v, mesa_ascii2nibble.v, 
//   mesa_byte2ascii.v, iob_bidi.v
//-----------------------------------------------------------------------------
ft232_xface u_ft232_xface
(
  .reset       ( reset_loc       ),
  .clk_lb      ( clk_100m_tree   ),
  .ftdi_wi     ( ftdi_wi         ),
  .ftdi_ro     ( ftdi_ro         ),
  .lb_wr       ( lb_wr           ),
  .lb_rd       ( lb_rd           ),
  .lb_addr     ( lb_addr[31:0]   ),
  .lb_wr_d     ( lb_wr_d[31:0]   ),
  .lb_rd_d     ( lb_rd_d[31:0]   ),
  .lb_rd_rdy   ( lb_rd_rdy       )
);// u_ft232_xface


//-----------------------------------------------------------------------------
// Sump3 Logic Analyzer
// Files available at https://github.com/blackmesalabs/sump3
//   sump3_top.v, sump3_core.v, sump3_rle_hub.v, sump3_rle_pod.v
//-----------------------------------------------------------------------------
sump3_top u_sump3_top
(
  .reset        ( reset_loc            ),
  .clk_lb       ( clk_100m_tree        ),
  .clk_cap      ( clk_100m_tree        ),
  .clk_dot      ( clk_108m_tree        ),
  .lb_cs_ctrl   ( sump3_lb_cs_ctrl     ),// Must be -4 from lb_cs_data
  .lb_cs_data   ( sump3_lb_cs_data     ),// Must be +4 from lb_cs_ctrl
  .lb_wr        ( lb_wr                ),
  .lb_rd        ( lb_rd                ),
  .lb_wr_d      ( lb_wr_d[31:0]        ),
  .lb_rd_d      ( lb_rd_d[31:0]        ),
  .lb_rd_rdy    ( lb_rd_rdy            ),
  .sumpd_events ( sumpd_events[15:0]   )
);// u_sump3_top
  assign sump3_lb_cs_ctrl = ( lb_addr[19:0] == 20'h00098 ) ? 1 : 0;
  assign sump3_lb_cs_data = ( lb_addr[19:0] == 20'h0009c ) ? 1 : 0;


endmodule // top.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
