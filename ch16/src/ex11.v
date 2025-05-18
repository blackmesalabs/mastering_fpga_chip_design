task task_check_counting;
  input [3:0] data_new;
  input [3:0] data_old;
  if ( data_new != data_old + 1 ) begin
    reset <= 1;
    #10
    reset <= 0;
    #40
    ;
  end
endtask
