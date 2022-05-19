module DSP48_inferred (
  clk ,
  rst_n,
  // Logic signals
  i_sel,
  // Data signals
  i_s18_X,
  i_s18_Y,
  i_s48_C,
  o_s48_XY_plus_C 
);
  
  input                 i_sel;
  input                 clk,rst_n;
  input  signed  [17:0] i_s18_X, i_s18_Y;
  input  signed  [47:0] i_s48_C;
 
  output signed  [47:0] o_s48_XY_plus_C;


  reg    signed  [17:0] s18_X_reg;
  reg    signed  [17:0] s18_Y_reg;

  // pipeline registers
  reg    signed  [47:0] s48_post_mlt_reg;
  reg    signed  [47:0] s48_post_acc_reg;

  assign o_s48_XY_plus_C = s48_post_acc_reg;


  // Synchronous reset
  always @(posedge clk ) begin
    if (!rst_n) begin
      // Rest all regs
      s18_X_reg <= 0 ;
      s18_Y_reg <= 0 ;
      s48_post_mlt_reg <= 0 ;
      s48_post_acc_reg <= 0 ;

    end else begin 


      // DSP operation
      //s18_X_reg <= i_s18_X;
      //s18_Y_reg <= i_s18_Y;

      s48_post_mlt_reg <= i_s18_X * i_s18_Y;

      if (i_sel) begin
        s48_post_acc_reg <= s48_post_mlt_reg + i_s48_C;  
      end else begin
        // Accumulate prev result
        s48_post_acc_reg <= s48_post_mlt_reg + s48_post_acc_reg;  
      end

    end
  end

endmodule