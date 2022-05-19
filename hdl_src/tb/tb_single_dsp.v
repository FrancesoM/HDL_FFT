`timescale 1ns/1ps

module Test_SS_CM_18x18;

    // Inputs
reg signed [17:0] A;
reg signed [17:0] B;
reg signed [47:0] C;

reg clk;
reg rst_n;

// Outputs
wire [47:0] O;

// Instantiate the Unit Under Test (UUT)
DSP48_inferred uut1 (
      .clk(clk),
      .rst_n(rst_n),
      .i_s18_X(A),
      .i_s18_Y(B),
      .i_s48_C(C),
      .o_s48_XY_plus_C(O) 
);

initial begin
    // Initialize Inputs
    A = -18'sd4;
    B = 18'sd3;
    C = -48'sd10;
    clk = 0;
    rst_n = 0;

    // Wait 100 ns for global reset to finish
    #100;
    #10 rst_n = 1;
    
    #50
    A = -18'sd5;
    B = 18'sd8;
    C = -48'sd7;

    #50

    #10 
    C = 0;
    #10 
    C = 10;
    #10 
    C = 0;
    #10 
    C = 10;

    
end
always #5 clk=~clk;      
endmodule 