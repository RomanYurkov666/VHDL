//Legal Notice: (C)2016 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rf_sopc_gpio (
                      // inputs:
                       address,
                       chipselect,
                       clk,
                       reset_n,
                       write_n,
                       writedata,

                      // outputs:
                       bidir_port,
                       readdata
                    )
;

  inout   [ 15: 0] bidir_port;
  output  [ 31: 0] readdata;
  input   [  2: 0] address;
  input            chipselect;
  input            clk;
  input            reset_n;
  input            write_n;
  input   [ 31: 0] writedata;

  wire    [ 15: 0] bidir_port;
  wire             clk_en;
  reg     [ 15: 0] data_dir;
  wire    [ 15: 0] data_in;
  reg     [ 15: 0] data_out;
  wire    [ 15: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  wire             wr_strobe;
  assign clk_en = 1;
  //s1, which is an e_avalon_slave
  assign read_mux_out = ({16 {(address == 0)}} & data_in) |
    ({16 {(address == 1)}} & data_dir);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end


  assign wr_strobe = chipselect && ~write_n;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (clk_en)
          if (wr_strobe)
              data_out <= (address == 5)? data_out & ~writedata[15 : 0]: (address == 4)? data_out | writedata[15 : 0]: (address == 0)? writedata[15 : 0]: data_out;
    end


  assign bidir_port[0] = data_dir[0] ? data_out[0] : 1'bZ;
  assign bidir_port[1] = data_dir[1] ? data_out[1] : 1'bZ;
  assign bidir_port[2] = data_dir[2] ? data_out[2] : 1'bZ;
  assign bidir_port[3] = data_dir[3] ? data_out[3] : 1'bZ;
  assign bidir_port[4] = data_dir[4] ? data_out[4] : 1'bZ;
  assign bidir_port[5] = data_dir[5] ? data_out[5] : 1'bZ;
  assign bidir_port[6] = data_dir[6] ? data_out[6] : 1'bZ;
  assign bidir_port[7] = data_dir[7] ? data_out[7] : 1'bZ;
  assign bidir_port[8] = data_dir[8] ? data_out[8] : 1'bZ;
  assign bidir_port[9] = data_dir[9] ? data_out[9] : 1'bZ;
  assign bidir_port[10] = data_dir[10] ? data_out[10] : 1'bZ;
  assign bidir_port[11] = data_dir[11] ? data_out[11] : 1'bZ;
  assign bidir_port[12] = data_dir[12] ? data_out[12] : 1'bZ;
  assign bidir_port[13] = data_dir[13] ? data_out[13] : 1'bZ;
  assign bidir_port[14] = data_dir[14] ? data_out[14] : 1'bZ;
  assign bidir_port[15] = data_dir[15] ? data_out[15] : 1'bZ;
  assign data_in = bidir_port;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_dir <= 0;
      else if (chipselect && ~write_n && (address == 1))
          data_dir <= writedata[15 : 0];
    end



endmodule
