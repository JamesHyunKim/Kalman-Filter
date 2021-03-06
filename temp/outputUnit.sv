// $Id: $
// File name:   outputUnit.sv
// Created:     4/15/2014
// Author:      Yuhao Chen
// Lab Section: 2
// Version:     1.0  Initial Design Entry
// Description: output logic for I2C sensor interface
module outputUnit
(
  input wire clk,
  input wire n_rst,
  input wire acc_read,
  input wire gyro_read,
  input wire mag_read,
  input wire acc_ready_i,
  input wire gyro_ready_i,
  input wire mag_ready_i,
  output reg acc_ready_o,
  output reg gyro_ready_o,
  output reg mag_ready_o
);

reg next_acc, next_gyro, next_mag;

//if the ready flag is raised, then we feed the input into the reg
//if the read flag is raised, we clear the flag
always_comb
begin
  next_acc = acc_ready_o;
  next_gyro = gyro_ready_o;
  next_mag = mag_ready_o;
  if (acc_ready_i == 1'b1)
    begin
      next_acc = 1;
    end
  if (gyro_ready_i == 1'b1)
    begin
      next_gyro = 1;
    end
  if (mag_ready_i == 1'b1)
    begin
      next_mag = 1;
    end
  if (acc_read == 1'b1)
    begin
      next_acc = 0;
    end  
  if (gyro_read == 1'b1)
    begin
      next_gyro = 0;
    end  
  if (mag_read == 1'b1)
    begin
      next_mag = 0;
    end  
end

always_ff @ (posedge clk, negedge n_rst)
begin
  if (n_rst == 0)
    begin
      acc_ready_o <= 0;
      gyro_ready_o <= 0;
      mag_ready_o <= 0;
    end
  else
    begin
      acc_ready_o <= next_acc;
      gyro_ready_o <= next_gyro;
      mag_ready_o <= next_mag;  
      
    end
end



endmodule