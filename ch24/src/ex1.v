always @ ( posedge clk ) begin
 if ( regional_ck_en == 1 ) begin
   my_cnt <= my_cnt[31:0] + 1;
 end
end
