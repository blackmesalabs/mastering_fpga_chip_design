always @ ( posedge clk ) begin
 lb_rd_rdy <= 0;
 if ( lb_rd == 1 ) begin
   claim_cnt   <= 4'd15;
   lb_rd_d_ram <= ram_array[lb_addr[11:2]];
 end else begin
   if ( claim_cnt != 4'd0 ) begin
     claim_cnt <= claim_cnt - 1;
     if ( claim_cnt == 4'd1 ) begin
       lb_rd_d   <= lb_rd_d_ram[31:0];
       lb_rd_rdy <= 1;
     end
     if ( u0_lb_rd_rdy == 1 ) begin
       claim_cnt <= 4'd0;
       lb_rd_d   <= u0_lb_rd_d[31:0];
       lb_rd_rdy <= 1;
     end
   end
 end
end
