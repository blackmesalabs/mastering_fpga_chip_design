integer file_in_ptr;
initial begin
 file_in_ptr = $fopen("stimulus.txt", "r");
end

reg [8*80:0] txt_in_line;

always @(posedge clk) begin
  if ($feof(file_in_ptr)) begin
    $fclose(file_in_ptr);
    $finish; 
  end else begin
    $fgets(  txt_in_line , file_in_ptr );
    $sscanf( txt_in_line ,"%1x %1x %1x", reset, load, din );
  end
end
