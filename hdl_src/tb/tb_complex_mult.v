`timescale 1ns/1ps

module Test_SS_CM_18x18;

    // Inputs
reg signed [17:0] AR;
reg signed [17:0] AI;
reg signed [17:0] BR;
reg signed [17:0] BI;

reg u1_valid_in;

reg clk;
reg rst_n;

// Outputs
wire [47:0] OR;
wire [47:0] OI;
wire u1_valid_out;

// Instantiate the Unit Under Test (UUT)
cplx_mult uut1  (
  .clk(clk) ,
  .rst_n(rst_n),
  .i_u1_valid_in(u1_valid_in),
  .o_u1_valid_out(u1_valid_out),
  .i_s18_AR(AR),  
  .i_s18_AI(AI), 
  .i_s18_BR(BR), 
  .i_s18_BI(BI),
  .o_s48_R(OR),
  .o_s48_I(OI)
);

initial begin
    // Initialize Inputs
    AR = -9830  ; //-0.15000000 
    AI = 51118  ; //+0.78000000 
    BR = -51511 ; //-0.78600000 
    BI = 3696   ; //+0.05640000  
    u1_valid_in = 0;
    clk = 0;
    rst_n = 0;

    // Wait 100 ns for global reset to finish
    #105; // +5 align with the clock
    #10 rst_n = 1;
    #50
    u1_valid_in = 1;
    #20
    u1_valid_in = 0;


    // Test data change back to back

    #300
    AR = -4981;  //  -0.07600403 
    AI = 19661;  //  +0.30000305 
    BR = -3277;  //  -0.05000305 
    BI = 4443 ;  //  +0.06779480 
    u1_valid_in = 1;
    #20
    AR = -9830  ; //-0.15000000 
    AI = 51118  ; //+0.78000000 
    BR = -51511 ; //-0.78600000 
    BI = 3696   ; //+0.05640000  
    #20
    u1_valid_in = 0;
    #20
    
    #100;

end
always #5 clk=~clk;      
endmodule 