 assign lb_addr = { 24'h000000, lb_addr_raw[7:2], 2'b00 };

 if ( lb_wr == 1 && lb_addr[31:0] == 32'h00000010 ) begin
   ctrl_a <= lb_wr_d[31:0];
 end
