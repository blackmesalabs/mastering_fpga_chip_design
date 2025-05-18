(* ram_style = "block" *) reg [width_bits-1:0] ram_array[depth_len-1:0];

always @( posedge a_clk )
begin
  if ( a_we == 1 ) begin
    ram_array[a_addr][width_bits-1:0] <= a_di[width_bits-1:0];
  end
end

always @( posedge b_clk )
begin
  b_do <= rle_ram_array[b_addr];
end
