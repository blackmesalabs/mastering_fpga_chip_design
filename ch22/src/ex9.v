 if ( ram_reset_cnt != 11'd1024 ) begin
   ram_reset_cnt <= ram_reset_cnt + 1;
   ram_array[ ram_reset_cnt[9:0] ] <= 32'd0;
   if ( ram_reset_cnt == 11'd2 ) begin
     ram_array[ ram_reset_cnt[9:0] ] <= 32'hAABBCCDD;
   end
 end else begin
   reset_complete <= 1;
 end
 if ( reset == 1 ) begin
   ram_reset_cnt  <= 11'd0;
   reset_complete <= 0;
 end
