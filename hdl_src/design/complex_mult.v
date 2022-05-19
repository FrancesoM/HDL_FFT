module cplx_mult (
  clk ,
  rst_n,
  // Sync signals
  i_u1_valid_in, //TODO: Add ready signal
  o_u1_valid_out,
  i_s18_AR,  i_s18_AI, i_s18_BR, i_s18_BI,
  // Higher precision signals, used to accumulate multiplications
  o_s48_R,
  o_s48_I
);


input  clk ;
input  rst_n;
input  i_u1_valid_in;

output  o_u1_valid_out;
input  signed  [17:0]   i_s18_AR,  i_s18_AI, i_s18_BR, i_s18_BI;

output signed  [47:0]   o_s48_R;
output signed  [47:0]   o_s48_I;

localparam READY = 1'b0;
localparam BUSY  = 1'b1;

reg state_reg ;

wire  signed [17:0] s18_X_real_path;
wire  signed [17:0] s18_Y_real_path;
wire  signed [17:0] s18_X_imag_path;
wire  signed [17:0] s18_Y_imag_path;

wire                u1_sel;

// The operands arrive all at the same time, but some of them are used at the second clock cycle
// So we register them, so that at the input they can change without affecting the computation
reg signed   [17:0] s18_AI_reg;
reg signed   [17:0] s18_neg_BI_reg; // We make it negative when we sample from input, to split crit path
reg signed   [17:0] s18_BR_reg;

reg          [2:0]  u3_valid_delay;

integer delay_idx;

DSP48_inferred DSP_real_path(
  .clk(clk) ,
  .rst_n(rst_n),
  .i_s18_X(s18_X_real_path),
  .i_s18_Y(s18_Y_real_path),
  .i_s48_C(0),
  .i_sel          (u1_sel),
  .o_s48_XY_plus_C(o_s48_R)
);

DSP48_inferred DSP_imag_path(
  .clk(clk) ,
  .rst_n(rst_n),
  .i_s18_X(s18_X_imag_path),
  .i_s18_Y(s18_Y_imag_path),
  .i_s48_C(0),
  .i_sel          (u1_sel),
  .o_s48_XY_plus_C(o_s48_I)
);

// R
assign s18_X_real_path = ~u1_sel ? i_s18_AR :  s18_AI_reg ;
assign s18_Y_real_path = ~u1_sel ? i_s18_BR :  s18_neg_BI_reg ; //This negative maybe

// I
assign s18_X_imag_path = ~u1_sel ? i_s18_AR : s18_AI_reg ;
assign s18_Y_imag_path = ~u1_sel ? i_s18_BI : s18_BR_reg ;

assign o_u1_valid_out =  u3_valid_delay[2];

assign u1_sel = (state_reg == BUSY) ? 1 : 0;

always @(posedge clk ) begin
  if (!rst_n) begin
    // Rest all regs

    s18_AI_reg     <= 0;
    s18_neg_BI_reg <= 0;
    s18_BR_reg     <= 0;

    u3_valid_delay <= 0;

    state_reg      <= READY;    

  end else begin 

    // Always do this - then tweak the valid out based on valid in
    // This works because the DSP latency is fixed, we just discard wrong results

    case( state_reg )

      READY:
      begin
        if ( i_u1_valid_in ) begin
          // Sample input
          s18_AI_reg     <=  i_s18_AI;
          s18_neg_BI_reg <= -i_s18_BI;
          s18_BR_reg     <=  i_s18_BR;

          u3_valid_delay[0] <= 1;

          state_reg <= BUSY;
        end else begin
          u3_valid_delay[0] <= 0;
        end
      end
      BUSY:
      begin 
        u3_valid_delay[0] <= 0;
        state_reg <= READY;
      end        
    endcase

    // Delay valid. We know that the multiplication result will be available in 2cc
    for(delay_idx = 1; delay_idx <3; delay_idx = delay_idx + 1) begin
      u3_valid_delay[delay_idx] <= u3_valid_delay[delay_idx-1];
    end

  end
end

endmodule