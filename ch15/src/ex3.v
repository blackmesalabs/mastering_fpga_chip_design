`timescale 1 ns/ 100 ps

module tb_top
(
  input  wire       clk,
  input  wire       reset,
  output wire [3:0] led
); // module tb_top


// --------------------------------------------------------
// Instantiate the Unit Under Test
// --------------------------------------------------------
top u_top
(
  .clk    ( clk      ),
  .reset  ( reset    ),
  .led    ( led[3:0] )
);

endmodule // tb_top
