`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module fifo #
(
  parameter depth_len  = 16,
  parameter depth_bits = 4,
  parameter width_bits = 8
)
(
  input  wire                  reset, 
  input  wire                  clk, 
  input  wire                  a_push_en,
  input  wire [width_bits-1:0] a_di,
  input  wire                  b_pop_en,
  output reg  [width_bits-1:0] b_do,
  output reg                   b_rdy,
  output reg                   flag_empty,
  output reg                   flag_almost_empty,
  output reg                   flag_almost_full,
  output reg                   flag_full
);


// ram_style : registers,distributed,block,ultra,mixed,auto
(* ram_style = "block" *) reg  [width_bits-1:0] ram_array[depth_len-1:0];
  reg  [depth_bits-1:0]   a_addr;
  reg  [depth_bits-1:0]   b_addr;
  reg  [depth_bits-1:0]   full_cnt;


//----------------------------------------------------------------
// Write Port of RAM
//----------------------------------------------------------------
always @( posedge clk )
begin
  if ( reset == 1 ) begin
    a_addr <= 0;
  end else begin
    if ( a_push_en == 1 ) begin
      ram_array[a_addr][width_bits-1:0] <= a_di[width_bits-1:0];
      a_addr                            <= a_addr[depth_bits-1:0]+1;
    end // if ( a_we )
  end
end // always


//----------------------------------------------------------------
// Read Port of RAM
//----------------------------------------------------------------
always @( posedge clk )
begin
  if ( reset == 1 ) begin
    b_addr <= 0;
    b_do   <= 0;
    b_rdy  <= 0;
  end else begin
    b_rdy  <= 0;
    if ( b_pop_en == 1 ) begin
      b_rdy  <= 1;
      b_do   <= ram_array[b_addr];
      b_addr <= b_addr[depth_bits-1:0]+1;
    end // if ( b_pop_en == 1 )
  end
end // always


//----------------------------------------------------------------
// Full Counter
//----------------------------------------------------------------
always @( posedge clk )
begin
  if ( reset == 1 ) begin
    full_cnt   <= 0;
  end else begin
    if          ( a_push_en == 1 && b_pop_en == 0 ) begin
      full_cnt <= full_cnt + 1;
    end else if ( a_push_en == 0 && b_pop_en == 1 ) begin
      full_cnt <= full_cnt - 1;
    end else begin
      full_cnt <= full_cnt[depth_bits-1:0];
    end
  end
end // always


//----------------------------------------------------------------
// Flags
//----------------------------------------------------------------
always @( posedge clk )
begin
  flag_empty        <= 0;
  flag_full         <= 0;
  flag_almost_empty <= 0;
  flag_almost_full  <= 0;
  if ( full_cnt[depth_bits-1:0] == 0 ) begin
    flag_empty <= 1;
  end
  if ( full_cnt[depth_bits-1:0] == 1 ) begin
    flag_almost_empty <= 1;
  end
  if ( full_cnt[depth_bits-1:0] == depth_len-1) begin
    flag_full  <= 1;
  end
  if ( full_cnt[depth_bits-1:0] == depth_len-2) begin
    flag_almost_full <= 1;
  end
end // always

endmodule // fifo
`default_nettype wire // enable default for 3rd party IP needing it
