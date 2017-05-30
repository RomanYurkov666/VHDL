// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/14.0/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2014/02/16 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module rangefinder_sopc_mm_interconnect_0_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 10 
   )
  (output [82 - 78 : 0] default_destination_id,
   output [25-1 : 0] default_wr_channel,
   output [25-1 : 0] default_rd_channel,
   output [25-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[82 - 78 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 25'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 25'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 25'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module rangefinder_sopc_mm_interconnect_0_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [96-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [96-1    : 0] src_data,
    output reg [25-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 51;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 82;
    localparam PKT_DEST_ID_L = 78;
    localparam PKT_PROTECTION_H = 86;
    localparam PKT_PROTECTION_L = 84;
    localparam ST_DATA_W = 96;
    localparam ST_CHANNEL_W = 25;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 54;
    localparam PKT_TRANS_READ  = 55;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h8000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h9000 - 64'h8800); 
    localparam PAD2 = log2ceil(64'h9100 - 64'h9000); 
    localparam PAD3 = log2ceil(64'h9140 - 64'h9100); 
    localparam PAD4 = log2ceil(64'h9160 - 64'h9140); 
    localparam PAD5 = log2ceil(64'h9180 - 64'h9160); 
    localparam PAD6 = log2ceil(64'h91a0 - 64'h9180); 
    localparam PAD7 = log2ceil(64'h91c0 - 64'h91a0); 
    localparam PAD8 = log2ceil(64'h91e0 - 64'h91c0); 
    localparam PAD9 = log2ceil(64'h9200 - 64'h91e0); 
    localparam PAD10 = log2ceil(64'h9220 - 64'h9200); 
    localparam PAD11 = log2ceil(64'h9240 - 64'h9220); 
    localparam PAD12 = log2ceil(64'h9260 - 64'h9240); 
    localparam PAD13 = log2ceil(64'h9280 - 64'h9260); 
    localparam PAD14 = log2ceil(64'h92a0 - 64'h9280); 
    localparam PAD15 = log2ceil(64'h92c0 - 64'h92a0); 
    localparam PAD16 = log2ceil(64'h92e0 - 64'h92c0); 
    localparam PAD17 = log2ceil(64'h92f0 - 64'h92e0); 
    localparam PAD18 = log2ceil(64'h9300 - 64'h92f0); 
    localparam PAD19 = log2ceil(64'h9310 - 64'h9300); 
    localparam PAD20 = log2ceil(64'h9320 - 64'h9310); 
    localparam PAD21 = log2ceil(64'h9330 - 64'h9320); 
    localparam PAD22 = log2ceil(64'h9340 - 64'h9330); 
    localparam PAD23 = log2ceil(64'h9348 - 64'h9340); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h9348;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [25-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    rangefinder_sopc_mm_interconnect_0_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x8000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 16'h0   ) begin
            src_channel = 25'b000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x8800 .. 0x9000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 16'h8800   ) begin
            src_channel = 25'b000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x9000 .. 0x9100 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 16'h9000  && read_transaction  ) begin
            src_channel = 25'b100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x9100 .. 0x9140 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 16'h9100   ) begin
            src_channel = 25'b010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x9140 .. 0x9160 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 16'h9140   ) begin
            src_channel = 25'b001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x9160 .. 0x9180 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 16'h9160   ) begin
            src_channel = 25'b000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x9180 .. 0x91a0 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 16'h9180   ) begin
            src_channel = 25'b000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x91a0 .. 0x91c0 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 16'h91a0   ) begin
            src_channel = 25'b000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x91c0 .. 0x91e0 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 16'h91c0   ) begin
            src_channel = 25'b000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x91e0 .. 0x9200 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 16'h91e0   ) begin
            src_channel = 25'b000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x9200 .. 0x9220 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 16'h9200   ) begin
            src_channel = 25'b000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x9220 .. 0x9240 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 16'h9220   ) begin
            src_channel = 25'b000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x9240 .. 0x9260 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 16'h9240   ) begin
            src_channel = 25'b000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x9260 .. 0x9280 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 16'h9260   ) begin
            src_channel = 25'b000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x9280 .. 0x92a0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 16'h9280   ) begin
            src_channel = 25'b000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x92a0 .. 0x92c0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 16'h92a0   ) begin
            src_channel = 25'b000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x92c0 .. 0x92e0 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 16'h92c0   ) begin
            src_channel = 25'b000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x92e0 .. 0x92f0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 16'h92e0   ) begin
            src_channel = 25'b000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x92f0 .. 0x9300 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 16'h92f0   ) begin
            src_channel = 25'b000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x9300 .. 0x9310 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 16'h9300   ) begin
            src_channel = 25'b000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x9310 .. 0x9320 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 16'h9310  && read_transaction  ) begin
            src_channel = 25'b000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x9320 .. 0x9330 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 16'h9320   ) begin
            src_channel = 25'b000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x9330 .. 0x9340 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 16'h9330   ) begin
            src_channel = 25'b000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x9340 .. 0x9348 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 16'h9340  && read_transaction  ) begin
            src_channel = 25'b000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


