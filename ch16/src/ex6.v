reg [8*80:0] txt_in_line;
reg [8*16:0] my_word;
reg [15:0]   wait_time;
integer j;

always @(posedge clk) begin
  if ($feof(file_in_ptr)) begin
    $fclose(file_in_ptr);
    $finish;
  end else begin
    $fgets(  txt_in_line , file_in_ptr ); // Grab entire Line
    $sscanf( txt_in_line ,"%s %d", my_word , wait_time );
    if ( my_word == "wait" ) begin
      $display("Waiting...%d", wait_time );
      for ( j = 0; j < wait_time; j=j+1 ) begin
        @( posedge clk );
      end // for j
    end else if ( my_word != "#" ) begin
      $sscanf( txt_in_line ,"%1x %1x %1x", reset, load, din );
    end
  end
end
