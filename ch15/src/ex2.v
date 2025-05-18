`timescale 1 ns/ 100 ps
`define CLK_PRD 10

module tb_top
(
); // module tb_top
  reg        clk;
  reg        reset;
  wire [3:0] led;

//-------------------------------------------------------------------
// Startup Stuff
//-------------------------------------------------------------------
initial
begin
  $display("Welcome to Iverilog Simulation");
  $dumpfile("tb_top.vcd");// VCD file for ModelSim or GTKwave
  $dumpvars(1, tb_top.u_top );// Dump only this level to VCD. 0=hier
end

//-------------------------------------------------------------------
// 100 MHz Clock Oscillator
//-------------------------------------------------------------------
initial
begin
  clk <= 0;
  #(`CLK_PRD/2) forever
   #(`CLK_PRD/2) clk <= ~ clk;
end

//-------------------------------------------------------------------
// Reset Pulse
//-------------------------------------------------------------------
initial
begin
  $display("In Reset        T=%t", $time);
  reset <= 1;
  #(`CLK_PRD)
  reset <= 0;
  $display("Out of Reset    T=%t", $time);
  #(`CLK_PRD*10)
  $display("End Simulation  T=%t", $time);
  $finish;
end

// ------------------------------------------------------------------
// Instantiate the Unit Under Test
// ------------------------------------------------------------------
top u_top
(
  .clk    ( clk      ),
  .reset  ( reset    ),
  .led    ( led[3:0] )
);

endmodule // tb_top
