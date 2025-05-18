function func_check_counting;
  input [3:0] data_new;
  input [3:0] data_old;
  if ( data_new == data_old + 1 ) begin
    func_check_counting = 1;
  end else begin
    func_check_counting = 0;
  end
endfunction
