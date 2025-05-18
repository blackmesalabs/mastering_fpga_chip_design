  reg [7:0]  cnt = 8'd0;
  reg        dir = 0;

always @(posedge clk) begin
  if ( dir == 0 ) begin
    cnt <= cnt + 1;
    if ( cnt == 8'h7F ) begin
      dir <= ~dir;
      cnt <= 8'h7E;
    end
  end else begin
    cnt <= cnt - 1;
    if ( cnt == 8'h80 ) begin
      dir <= ~dir;
      cnt <= 8'h81;
    end
  end
end
