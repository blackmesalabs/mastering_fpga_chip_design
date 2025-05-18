always @ ( posedge clk_333m ) begin
//if ( cnt_a_p1 != 40'd0 ||
//     cnt_b_p1 != 40'd0 ||         
//     cnt_c_p1 != 40'd0    ) begin 
//  not_all_zero <= 1;
//end else begin
//  not_all_zero <= 0;
//end
  not_all_zero_pre <= 3'd0;
  if ( cnt_a_p1 != 40'd0 ) begin
    not_all_zero_pre[0] <= 1;   
  end
  if ( cnt_b_p1 != 40'd0 ) begin
    not_all_zero_pre[1] <= 1;   
  end
  if ( cnt_c_p1 != 40'd0 ) begin
    not_all_zero_pre[2] <= 1;   
  end
  not_all_zero <= |not_all_zero_pre[2:0];// OR Reduction Operator
end
