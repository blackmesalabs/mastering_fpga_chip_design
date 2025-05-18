def some_filter( input_list ):
  output_list = [];
  for each_line in input_list:
    words = " ".join(each_line.split()).split(' ') + [None] * 4;
    output_list += [ words[0] ];
  return output_list;
