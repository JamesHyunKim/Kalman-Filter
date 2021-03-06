// $Id: $
// File name:   flex_8bitstp_sr.sv
// Created:     4/16/2014
// Author:      Yuhao Chen
// Lab Section: 2
// Version:     1.0  Initial Design Entry
// Description: 8 bit wide sr
// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/5/2014
// Author:      Yuhao Chen
// Lab Section: 2
// Version:     1.0  Initial Design Entry
// Description: the previous file does not have .sv

module flex_8bitstp_sr
#(
  parameter NUM_BYTES = 6,
  parameter SHIFT_MSB = 1
)
(
  input wire clk,
  input wire n_rst,
  input wire shift_enable,
  input wire [7:0] serial_in,
  output wire [NUM_BYTES * 8 - 1:0] parallel_out  
);

reg [NUM_BYTES * 8 - 1:0] val;
reg [NUM_BYTES * 8 - 1:0] next_val;

assign parallel_out = val;

always_ff @ (posedge clk, negedge n_rst)
begin
  //reset
  if (n_rst == 1'b0)
  begin
    val = 0;
  end
  else
  begin
    val = next_val;
  end
  
end

always_comb
begin
  next_val = val;
    //enable shift
    if (shift_enable == 1'b1)
    begin
      //shift left
      if (SHIFT_MSB == 1)
      begin
        next_val = { val[NUM_BYTES * 8 - 9:0], serial_in };     
      end
      else
      //shift right
      begin
        next_val = { serial_in, val[NUM_BYTES * 8 - 1:8] };
      end
    end //end enable shift
end

endmodule
