always @ ( posedge clk ) begin
  case( addr )
    8'h00 : data <= 8'h00;
    ..
    8'hFF : data <= 8'h38;
  endcase
end

OR 

reg [7:0] rom_array [255:0];
initial begin
  rom_array[   0 ] = 8'h00;
  ..
  rom_array[ 255 ] = 8'h38;
end

always @ (posedge clk)
begin
  data <= rom_array[ addr ];
end
