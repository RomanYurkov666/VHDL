module rec_channel_switch
(
	input reset,
	input clk,
	input [2:0] active_channel,
	input dma_rd_req,
	output [5:0] ch_read_req,
	input [7:0] fifo_0_q,
	input [7:0] fifo_0_usdw,
	input [7:0] fifo_1_q,
	input [7:0] fifo_1_usdw,
	input [7:0] fifo_2_q,
	input [7:0] fifo_2_usdw,
	input [7:0] fifo_3_q,
	input [7:0] fifo_3_usdw,
	input [7:0] fifo_4_q,
	input [7:0] fifo_4_usdw,
	input [7:0] fifo_5_q,
	input [7:0] fifo_5_usdw,
	output [7:0] fifo_q,
	output [7:0] fifo_usdw
);

reg [7:0] q = 0;
reg [7:0] usdw = 0;
reg [5:0] rdreq_en = 6'h0;

assign fifo_q = q;
assign fifo_usdw = usdw;
assign ch_read_req = rdreq_en & {6{dma_rd_req}};

always@ (posedge clk)
	begin
		if (reset)
			begin
				q <= 8'h0;
				usdw <= 8'h0;
				rdreq_en <= 6'h0;
			end 
		else
			begin
				case (active_channel)
				0: begin
				q <= fifo_0_q;
				usdw <= fifo_0_usdw;
				rdreq_en <= 6'b000001;
				end 
				1: begin
				q <= fifo_1_q;
				usdw <= fifo_1_usdw;
				rdreq_en <= 6'b000010;
				end 
				2: begin
				q <= fifo_2_q;
				usdw <= fifo_2_usdw;
				rdreq_en <= 6'b000100;
				end 
				3: begin
				q <= fifo_3_q;
				usdw <= fifo_3_usdw;
				rdreq_en <= 6'b001000;
				end 
				4: begin
				q <= fifo_4_q;
				usdw <= fifo_4_usdw;
				rdreq_en <= 6'b010000;
				end 
				5: begin
				q <= fifo_5_q;
				usdw <= fifo_5_usdw;
				rdreq_en <= 6'b100000;
				end 
				default: begin
				q <= 8'h0;
				usdw <= 8'h0;
				rdreq_en <= 6'b000000;
				end 
				endcase 
			end 
	end 



endmodule 