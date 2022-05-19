module btfly_op(
  clk ,
  rst_n,
  // Sync signals
  i_u1_valid_in,
  o_u1_valid_out,
  i_s18_V0_R,  i_s18_V0_I, i_s18_V1_R, i_s18_V1_I,
  i_s18_T0_R,  i_s18_T0_I, i_s18_T1_R, i_s18_T1_I,

  o_s18_O0_R, o_s18_O0_I,
  o_s18_O1_R, o_s18_O1_I
);

input  clk ;
input  rst_n;
  // Sync signal;
input  i_u1_valid_in;
output  o_u1_valid_out;
input signed [17:0] i_s18_V0_R,  i_s18_V0_I, i_s18_V1_R, i_s18_V1_I;
input signed [17:0] i_s18_T0_R,  i_s18_T0_I, i_s18_T1_R, i_s18_T1_I;
  // Higher precision signals, used to accumulate multiplication;
output signed [17:0]  o_s18_O0_R, o_s18_O0_I;
output signed [17:0]  o_s18_O1_R, o_s18_O1_I;

// V0 and V1 arrive at the same time, but there is latency so v0 must wait in registers
// Complex mult works at full pipeline so we can just stream samples in 

// Operations are : multiply - sum - resize FP - divide by two

// cplx mult gives 1 sample each two clock cycles 

wire u1_complex_mult_I_valid, u1_complex_mult_II_valid;

// Summation group
wire signed [17:0] s18_T0V1_V0_R; 
wire signed [17:0] s18_T0V1_V0_I; 
wire signed [17:0] s18_T1V1_V0_R; 
wire signed [17:0] s18_T1V1_V0_I; 

// Resized group
wire signed [17:0] s18_T0V1_R_resized; 
wire signed [17:0] s18_T0V1_I_resized; 
wire signed [17:0] s18_T1V1_R_resized; 
wire signed [17:0] s18_T1V1_I_resized; 

// Full precision group
wire signed [47:0] s48_T0V1_R;
wire signed [47:0] s48_T0V1_I;
wire signed [47:0] s48_T1V1_R;
wire signed [47:0] s48_T1V1_I;


// Delay regs
reg signed  [17:0]   s18_V0_R_pipe_i ;
reg signed  [17:0]   s18_V0_R_pipe_ii;
reg signed  [17:0]   s18_V0_I_pipe_i ;
reg signed  [17:0]   s18_V0_I_pipe_ii;

assign o_u1_valid_out = u1_complex_mult_I_valid  || u1_complex_mult_II_valid; //OR

// Resize the output, add  and divide by two. 
// Rounding mode? This is trunctation and it's not good 
assign s18_T0V1_R_resized = s48_T0V1_R[16+18-1:16];
assign s18_T0V1_I_resized = s48_T0V1_I[16+18-1:16];
assign s18_T1V1_R_resized = s48_T1V1_R[16+18-1:16];
assign s18_T1V1_I_resized = s48_T1V1_I[16+18-1:16];

assign s18_T0V1_V0_R  = s18_T0V1_R_resized + s18_V0_R_pipe_ii;
assign s18_T0V1_V0_I  = s18_T0V1_I_resized + s18_V0_I_pipe_ii;
assign s18_T1V1_V0_R  = s18_T1V1_R_resized + s18_V0_R_pipe_ii;
assign s18_T1V1_V0_I  = s18_T1V1_I_resized + s18_V0_I_pipe_ii;

// Last is bit shift with sign extension
assign o_s18_O0_R[17] = s18_T0V1_V0_R[17] ;
assign o_s18_O0_I[17] = s18_T0V1_V0_I[17];
assign o_s18_O1_R[17] = s18_T1V1_V0_R[17] ;
assign o_s18_O1_I[17] = s18_T1V1_V0_I[17];

assign o_s18_O0_R[16:0] = s18_T0V1_V0_R[17:1]; 
assign o_s18_O0_I[16:0] = s18_T0V1_V0_I[17:1];
assign o_s18_O1_R[16:0] = s18_T1V1_V0_R[17:1]; 
assign o_s18_O1_I[16:0] = s18_T1V1_V0_I[17:1];

cplx_mult complex_mult_I(
  .clk (clk),
  .rst_n(rst_n),
  .i_u1_valid_in(i_u1_valid_in),
  .o_u1_valid_out(u1_complex_mult_I_valid),
  .i_s18_AR(i_s18_V1_R), .i_s18_AI(i_s18_V1_I), 
  .i_s18_BR(i_s18_T0_R), .i_s18_BI(i_s18_T0_I),
  .o_s48_R(s48_T0V1_R),
  .o_s48_I(s48_T0V1_I)
);

cplx_mult complex_mult_II(
  .clk (clk),
  .rst_n(rst_n),
  .i_u1_valid_in(i_u1_valid_in),
  .o_u1_valid_out(u1_complex_mult_II_valid),
  .i_s18_AR(i_s18_V1_R), .i_s18_AI(i_s18_V1_I), 
  .i_s18_BR(i_s18_T1_R), .i_s18_BI(i_s18_T1_I),
  .o_s48_R(s48_T1V1_R),
  .o_s48_I(s48_T1V1_I)
);

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