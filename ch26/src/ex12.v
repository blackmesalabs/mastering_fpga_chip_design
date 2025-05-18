//-----------------------------------------------------------------------------
// Check for valid input parameters. Unknown halt_synthesis will halt synthesis
//-----------------------------------------------------------------------------
generate
  if ( 2**ram_depth_bits != ram_depth_len ) begin
    halt_synthesis_bad_ram_length();
  end
endgenerate
