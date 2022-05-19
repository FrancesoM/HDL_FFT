`timescale 1ns/1ps

module Test_BTFLY_18x18S;

    // Inputs
reg signed [17:0] i_s18_V0_R;
reg signed [17:0] i_s18_V0_I;
reg signed [17:0] i_s18_V1_R;
reg signed [17:0] i_s18_V1_I;
reg signed [17:0] i_s18_T0_R;
reg signed [17:0] i_s18_T0_I;
reg signed [17:0] i_s18_T1_R;
reg signed [17:0] i_s18_T1_I;

// Outputs
wire signed [17:0] o_s18_O0_R;
wire signed [17:0] o_s18_O0_I;
wire signed [17:0] o_s18_O1_R;
wire signed [17:0] o_s18_O1_I;

reg i_u1_valid_in;

reg clk;
reg rst_n;

// Outputs
wire o_u1_valid_out;

// Instantiate the Unit Under Test (UUT)
btfly_op btfly(
  .clk(clk) ,
  .rst_n(rst_n),
  .i_u1_valid_in(i_u1_valid_in),
  .o_u1_valid_out(o_u1_valid_out),
  .i_s18_V0_R(i_s18_V0_R),  
  .i_s18_V0_I(i_s18_V0_I),
  .i_s18_V1_R(i_s18_V1_R), 
  .i_s18_V1_I(i_s18_V1_I),
  .i_s18_T0_R(i_s18_T0_R),  
  .i_s18_T0_I(i_s18_T0_I), 
  .i_s18_T1_R(i_s18_T1_R), 
  .i_s18_T1_I(i_s18_T1_I),
  .o_s18_O0_R(o_s18_O0_R), 
  .o_s18_O0_I(o_s18_O0_I),
  .o_s18_O1_R(o_s18_O1_R), 
  .o_s18_O1_I(o_s18_O1_I)
);

initial begin
    // Initialize Inputs

    // Float: o0 = (-0.023293999999999995+0.337822j) , o1 = (-0.1017712+0.334378j)
    // Fixed: o0 = (-0.02332+0.33781j) , o1 = (-0.10179+0.33437j)

    i_s18_V0_R = -4981  ; // -0.07600000  re_v0_fixed:: 
    i_s18_V0_I = 19661  ; // +0.30000000  im_v0_fixed:: 
    i_s18_V1_R = -3277  ; // -0.05000000  re_v1_fixed:: 
    i_s18_V1_I = 4443   ; // +0.06780000  im_v1_fixed:  
    i_s18_T0_R = -655   ; //  -0.01000000 re_tw0_fixed: 
    i_s18_T0_I = -50463 ; //  -0.77000000 im_tw0_fixed: 
    i_s18_T1_R = 33423  ; //  +0.51000000 re_tw1_fixed: 
    i_s18_T1_I = 262    ; //  +0.00400000 im_tw1_fixed: 

    // Keep system in reset
    i_u1_valid_in = 0;
    clk = 0;
    rst_n = 0;

    // Wait 100 ns for global reset to finish
    #105; // +5 align data with the clock
    #10 rst_n = 1;
    #50
    i_u1_valid_in = 1;

    #300
    // AR = -4981;  //  -0.07600403 
    // AI = 19661;  //  +0.30000305 
    // BR = -3277;  //  -0.05000305 
    // BI = 4443 ;  //  +0.06779480 

    // Test inputs changing every two clock cycles
    i_s18_V0_R = 0 ;
    i_s18_V0_I = 0 ;
    i_s18_V1_R = 0 ;
    i_s18_V1_I = 0 ;
    i_s18_T0_R = 0 ;
    i_s18_T0_I = 0 ;
    i_s18_T1_R = 0 ;
    i_s18_T1_I = 0 ;


    #20;


    // Float: o0 = (-0.098712+1.384656j) , o1 = (-0.5510856000000001+0.80562j)
    // Fixed: o0 = (-0.09872+1.38464j) , o1 = (-0.55109+0.80562j)
    
    // Test inputs changing every two clock cycles
    i_s18_V0_R = -9830 ;  // float: -0.15000000  re_v0_fixed:: 
    i_s18_V0_I = 51118 ;  // float: +0.78000000  im_v0_fixed:: 
    i_s18_V1_R = -51511;  // float: -0.78600000  re_v1_fixed:: 
    i_s18_V1_I = 3696  ;  // float: +0.05640000  im_v1_fixed: :
    i_s18_T0_R = -655  ;  //  float: -0.0100000  re_tw0_fixed::
    i_s18_T0_I = -50463;  //  float: -0.7700000  im_tw0_fixed::
    i_s18_T1_R = 33423 ;  //  float: +0.5100000  re_tw1_fixed::
    i_s18_T1_I = 262   ;  // :float: +0.0040000  im_tw1_fixed: 

    #20

    i_s18_V0_R = 0 ;
    i_s18_V0_I = 0 ;
    i_s18_V1_R = 0 ;
    i_s18_V1_I = 0 ;
    i_s18_T0_R = 0 ;
    i_s18_T0_I = 0 ;
    i_s18_T1_R = 0 ;
    i_s18_T1_I = 0 ;

    #20

    // Float: o0 = (-0.023293999999999995+0.337822j) , o1 = (-0.1017712+0.334378j)
    // Fixed: o0 = (-0.02332+0.33781j) , o1 = (-0.10179+0.33437j)

    i_s18_V0_R = -4981  ; // -0.07600000  re_v0_fixed:: 
    i_s18_V0_I = 19661  ; // +0.30000000  im_v0_fixed:: 
    i_s18_V1_R = -3277  ; // -0.05000000  re_v1_fixed:: 
    i_s18_V1_I = 4443   ; // +0.06780000  im_v1_fixed:  
    i_s18_T0_R = -655   ; //  -0.01000000 re_tw0_fixed: 
    i_s18_T0_I = -50463 ; //  -0.77000000 im_tw0_fixed: 
    i_s18_T1_R = 33423  ; //  +0.51000000 re_tw1_fixed: 
    i_s18_T1_I = 262    ; //  +0.00400000 im_tw1_fixed: 


    #100;

end
always #5 clk=~clk;      
endmodule 