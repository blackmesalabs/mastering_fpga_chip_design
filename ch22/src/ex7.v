always @ ( posedge clk ) begin
 if ( lb_wr == 1 ) begin
   case( lb_addr[31:0] )
     32'h00000010 : ctrl_a <= lb_wr_d[31:0];
     32'h00000014 : ctrl_b <= lb_wr_d[31:0];
     32'h00000018 : ctrl_c <= lb_wr_d[31:0];
   endcase
 end
end

always @ ( posedge clk ) begin
 lb_rd_rdy <= 0;
 if ( lb_rd == 1 ) begin
   case( lb_addr[31:0] )
     32'h00000010 : begin lb_rd_d <= ctrl_a[31:0]; lb_rd_rdy <= 1; end
     32'h00000014 : begin lb_rd_d <= ctrl_b[31:0]; lb_rd_rdy <= 1; end
     32'h00000018 : begin lb_rd_d <= ctrl_c[31:0]; lb_rd_rdy <= 1; end
     default      : begin lb_rd_d <= 32'd0;        lb_rd_rdy <= 0; end
   endcase
 end
end
