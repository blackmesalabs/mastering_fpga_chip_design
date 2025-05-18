`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module core
(
  input  wire        clk,
  input  wire        reset,
  output wire [3:0]  up_cnt,
  output wire [3:0]  down_cnt
);// module core

  reg  [2:0]  enable_sr  = 3'b000;
  wire        enable_loc;
  wire [1:0]  inc_en = 2'b01;
  wire [1:0]  dec_en = 2'b10;
  wire [7:0]  cnt_loc;

//---------------------------------------------------------
// Synchronous enable well after asynch reset.
//---------------------------------------------------------
always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    enable_sr <= 3'b000;
  end else begin
    enable_sr <= { enable_sr[1:0], 1'b1 };
  end
end
  assign enable_loc = enable_sr[2];

//---------------------------------------------------------
// Instantiate two nibble counters
//---------------------------------------------------------
genvar i1;
generate
for ( i1=0; i1<=1; i1=i1+1 ) begin: gen_i1
 my_74193 u_my_74193
 (
   .clk     ( clk                     ),
   .reset   ( reset                   ),
   .load_en ( 1'b0                    ),
   .din     ( 4'd0                    ),
   .inc_en  ( inc_en[i1] & enable_loc ),
   .dec_en  ( dec_en[i1] & enable_loc ),
   .dout    ( cnt_loc[i1*4+3:i1*4+0]  )
 );// my_74193
end
endgenerate
  assign up_cnt   = cnt_loc[3:0];
  assign down_cnt = cnt_loc[7:4];

endmodule // core.v
`default_nettype wire // enable default for any 3rd party IP needing it
