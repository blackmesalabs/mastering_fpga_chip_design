initial begin
  $dumpfile("tb_counter.vcd");// VCD file for GTKwave
  $dumpvars(1, tb_counter.u_counter );// 1=this, 0=hier
end
