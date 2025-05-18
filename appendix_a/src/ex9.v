localparam[1:0]
  FSM_ST_ZERO = 2'h0,
  FSM_ST_ONE  = 2'h1;
reg [1:0] fsm_st = FSM_ST_ZERO;

always @ ( posedge clk or posedge reset ) begin
  if ( reset == 1 ) begin
    fsm_st <= FSM_ST_ZERO;
  end else begin
    case( fsm_st )
      FSM_ST_ZERO  : begin
          fsm_st <= FSM_ST_ONE;
        end
      FSM_ST_ONE   : begin
          fsm_st <= FSM_ST_ZERO;
        end
      default : begin
          fsm_st <= FSM_ST_ZERO;
        end
    endcase // fsm_st
  end
end 
