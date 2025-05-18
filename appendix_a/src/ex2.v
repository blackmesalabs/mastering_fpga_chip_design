`timescale 1 ns/ 100 ps
`default_nettype none

module foo
(         
  input  wire       clk,
  output wire [3:0] bar 
);// foo                
  reg    abc = 1'b0;
endmodule // foo.v
`default_nettype wire
