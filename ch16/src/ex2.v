`default_nettype none // Strictly enforce all nets to be declared
`timescale 1 ns/ 100 ps

module tb_counter
(
); // module tb_counter

  reg        reset;
  reg        clk;
  reg        load;
  reg  [3:0] din;
  wire [3:0] dout;

initial
begin
  clk <= 0;
  #5 forever
    #5 clk <= ~clk;
end

initial
begin
  #1
  reset <= 1; load <= 0; din <= 4'h0; #10
  reset <= 0; #40
  load  <= 1; din <= 4'hA; #10
  load  <= 0; din <= 4'h0; #40
  $finish;
end

counter u_counter
(
  .reset  ( reset     ),   
  .clk    ( clk       ),   
  .load   ( load      ),   
  .din    ( din[3:0]  ),   
  .dout   ( dout[3:0] )    
);

endmodule // tb_counter
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
