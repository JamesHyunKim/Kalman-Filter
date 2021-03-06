// $Id: $
// File name:   dataReg.sv
// Created:     4/15/2014
// Author:      Yuhao Chen
// Lab Section: 2
// Version:     1.0  Initial Design Entry
// Description: address pointer for I2C input device

module dataReg
(
  input wire clk,
  input wire n_rst,
  input wire [1:0] devicematch,
  input wire shift_strobe,
  input wire load_address,
  output reg acc_ready,
  output reg gyro_ready,
  output reg mag_ready,
  output reg [47:0] acc_data,
  output reg [47:0] gyro_data,
  output reg [47:0] mag_data,
  input wire [7:0] rx_write_data
);

reg [1:0] match;
reg [1:0] next_match;
reg rollover_flag;

//next logic for load address
always_comb
begin
  next_match = match;
  if (load_address == 1)
    begin
      next_match = devicematch;
    end
  else if (rollover_flag == 1)
    begin
      next_match = 0;
    end
end

//load address
always_ff @ (posedge clk, negedge n_rst)
begin
  if (n_rst == 0)
    begin
      match = 0;
    end
  else
    begin
      match = next_match;
    end
end

//mux
reg [2:0] shift_enable;

always_comb
begin
  shift_enable = 0;
  if (match == 1)
    begin
      shift_enable = {2'b00, shift_strobe};
    end
  if (match == 2)
    begin
      shift_enable = {1'b0, shift_strobe, 1'b0};
    end
  if (match == 3)
    begin
      shift_enable = {shift_strobe, 2'b00};
    end
end

//counter part
wire [2:0] rollover_val;
wire [2:0] count_out;

assign rollover_val = 6;
defparam XI.NUM_CNT_BITS = 3;
flex_counter XI(.clk(clk), .n_rst(n_rst), .clear(rollover_flag), .count_enable(shift_strobe), .rollover_val(rollover_val), .count_out(count_out), .rollover_flag(rollover_flag));

//mux for counter

always_comb
begin
  acc_ready = 0;
  gyro_ready = 0;
  mag_ready = 0;
  if (match == 1)
    begin
      acc_ready = rollover_flag;
      gyro_ready = 0;
      mag_ready = 0;
    end
  if (match == 2)
    begin
      acc_ready = 0;
      gyro_ready = rollover_flag;
      mag_ready = 0;
    end
  if (match == 3)
    begin
      acc_ready = 0;
      gyro_ready = 0;
      mag_ready = rollover_flag;
    end
end
//shift register

flex_8bitstp_sr ACC(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable[0]), .serial_in(rx_write_data), .parallel_out(acc_data));
flex_8bitstp_sr GYRO(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable[1]), .serial_in(rx_write_data), .parallel_out(gyro_data));
flex_8bitstp_sr MAG(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable[2]), .serial_in(rx_write_data), .parallel_out(mag_data));



endmodule