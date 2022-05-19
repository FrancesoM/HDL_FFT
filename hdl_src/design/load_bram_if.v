module load_bram_if #(
  parameter DATA_WIDTH = 18,                       // Specify RAM data width
  parameter DATA_DEPTH = 1024,                     // Specify RAM depth (number of entries)
) (
  output [clogb2(DATA_DEPTH-1)-1:0] o_addra, // Address bus, width determined from RAM_DEPTH
  input  clka,                              // Clock
  input  rsta,                              // Output reset (does not affect memory contents)
  input [DATA_WIDTH-1:0] i_bram_out          // RAM output data
);

  // This vector has log2(N)*N data, each DATA_WIDTH wide
  // log2(N) are the fft stages
  // N are the fft data
  reg [DATA_WIDTH-1:0] index_lookup [clogb2(DATA_DEPTH-1)-1:0][DATA_DEPTH-1:0];
  
  always @(posedge clk ) begin
    if (!rst_n) begin
      // Rest all regs


    end else begin 


    end
  end

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule