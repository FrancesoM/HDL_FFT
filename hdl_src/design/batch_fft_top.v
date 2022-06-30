module batch_fft_top(
  clk ,
  rst_n,
  // Input start and data
  i_u1_start,
  i_s18_2048_din,

  // Output valid and data
  o_u1_done,
  o_s18_2048_dout
);

parameter SAMPLE_WIDTH = 18,
          SAMPLE_DEPTH = 2048,
          FFT_STAGES   = 12;

input  clk ;
input  rst_n;

input i_u1_start;
output o_u1_done;

input  signed [SAMPLE_WIDTH-1:0]  i_s18_2048_din[SAMPLE_DEPTH-1:0];
output signed [SAMPLE_WIDTH-1:0] o_s18_2048_dout[SAMPLE_DEPTH-1:0];

wire signed [SAMPLE_WIDTH-1:0] s18_2048_post_stage[SAMPLE_DEPTH-1:0];
wire signed [SAMPLE_WIDTH-1:0] s18_2048_pre_stage[SAMPLE_DEPTH-1:0];

reg signed [SAMPLE_WIDTH-1:0] s18_2048_stage_r[SAMPLE_DEPTH-1:0];


always @(posedge clk ) begin
  if (!rst_n) begin
    // Rest all regs

    s18_V0_R_pipe_i <= 0;
    s18_V0_R_pipe_ii <= 0;

    s18_V0_I_pipe_i <= 0;
    s18_V0_I_pipe_ii <= 0;

  end else begin 

    // Advance pipeline onlu if valid
    if( i_u1_valid_in ) begin

      s18_V0_R_pipe_i <= i_s18_V0_R;
      s18_V0_R_pipe_ii <= s18_V0_R_pipe_i;

      s18_V0_I_pipe_i <= i_s18_V0_I;
      s18_V0_I_pipe_ii <= s18_V0_I_pipe_i;

    end
  end
end

endmodule