  reg  [31:0] ram_array[1023:0];

always @ ( posedge clk ) begin
 if ( lb_wr == 1 ) begin
   ram_array[lb_addr[11:2]] <= lb_wr_d[31:0];
 end
end

always @ ( posedge clk ) begin
 lb_rd_rdy <= 0;
 if ( lb_rd == 1 ) begin
   case( lb_addr[31:0] )
     32'h00000010 : lb_rd_rdy <= 1;
     32'h00000014 : lb_rd_rdy <= 1;
     32'h00000018 : lb_rd_rdy <= 1;
     default      : lb_rd_rdy <= 0;
   endcase
   lb_rd_d_ram <= ram_array[lb_addr[11:2]];
 end
end
