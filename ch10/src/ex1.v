`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module ram_36kb_1Kx36_2ck_1w1r #
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

  input  wire [depth_bits-1:0] b_addr,
  output wire [width_bits-1:0] b_do
);


// ram_style : registers,distributed,block,ultra,mixed,auto
(* ram_style = "block" *) reg  [width_bits-1:0] rle_ram_array[depth_len-1:0];
  reg                     a_we_p1;
  reg  [width_bits-1:0]   a_di_p1;
  reg  [depth_bits-1:0]   a_addr_p1;
  reg  [depth_bits-1:0]   b_addr_p1;
  reg  [width_bits-1:0]   b_do_loc;


//----------------------------------------------------------------
// Write Port of RAM
//----------------------------------------------------------------
always @( posedge a_clk )
begin
  if ( a_en == 1 && sleep == 0 ) begin
    a_we_p1   <= a_we;
    a_addr_p1 <= a_addr;
    a_di_p1   <= a_di;
    if ( a_we_p1 == 1 ) begin
      rle_ram_array[a_addr_p1][width_bits-1:0] <= a_di_p1[width_bits-1:0];
    end // if ( a_we )
  end
end // always


//----------------------------------------------------------------
// Read Port of RAM
//----------------------------------------------------------------
always @( posedge b_clk )
begin
  if ( b_en == 1 && sleep == 0 ) begin
    b_addr_p1 <= b_addr;
    b_do_loc  <= rle_ram_array[b_addr_p1];
  end
end // always
  assign b_do = b_do_loc[width_bits-1:0];


endmodule // ram_36kb_1Kx36_2ck_1w1r
`default_nettype wire // enable default for 3rd party IP needing it
