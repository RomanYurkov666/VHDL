module recording_channel
(
	input reset, 				//aclr for fifo
	input clk, 					//fast clk (adc domain)
	input [7:0] fifo_d,			//data for writing in fifo 
	input start_pulse,			//start for recording channel
	input stop_pulse,			//stop recording (with optional delay)
	input stop_recording, 		//if there were no comp pulse, but its neccessary to stop recording
	input [7:0] stop_delay, 	//delay in clk cycles
	input [12:0] abs_counter,	//timestamp from counter
	input fifo_read_request, 	//request for reading from fifo
	output reg echo_pulse_detected,	//pulse detected
	output reg [7:0] sample_length, //length of sample, stored in fifo 
	output [7:0] fifo_usdw,		//current cnt of words in fifo (address for writing in buf RAM)
	output [7:0] fifo_q,		//fifo output 
	output reg [12:0] timestamp		//stop pulse timestamp
);

localparam fifo_depth = 256;

reg [7:0] record_delay_cntr = 8'h00;
reg delay_cntr_en = 1'b0;
reg fifo_wren_strobe = 1'b0;
reg fifo_wren1 = 1'b0;
reg [7:0] fifo_d1 = 8'h0;

wire fifo_wren;
wire delay_cntr_en_set,delay_cntr_en_reset;
wire delay_cntr_rst;
wire fifo_full;
wire shifting_rd_req;

assign delay_cntr_en_set = stop_pulse;
assign delay_cntr_en_reset = (record_delay_cntr[7:0] == stop_delay[7:0]);
assign delay_cntr_rst = start_pulse | reset;
assign fifo_wren = fifo_wren_strobe|delay_cntr_en;
assign shifting_rd_req = fifo_wren&(fifo_usdw==(fifo_depth-1));

always@ (posedge clk)
	if (stop_pulse|stop_recording)
		fifo_wren_strobe <= 1'b0;
	else if (start_pulse)
		fifo_wren_strobe <= 1'b1;

always@ (posedge clk)
	if (delay_cntr_en_reset)
		delay_cntr_en<=1'b0;
	else if (delay_cntr_en_set)
		delay_cntr_en<=1'b1;

always@ (posedge clk)
	if (delay_cntr_rst)
		record_delay_cntr <= 8'h00;
	else if (delay_cntr_en)
		record_delay_cntr <= record_delay_cntr + 1'b1;
		
always@ (posedge clk)
	if (reset)
		timestamp<=13'h00;
	else if (stop_pulse)
		timestamp[12:0] <= abs_counter;
		
always@ (posedge clk)
	if (reset|start_pulse)
		echo_pulse_detected <= 0;
	else if (stop_pulse)
		echo_pulse_detected <= 1;
		
always@ (posedge clk)
	if (reset|start_pulse)
		sample_length <= 0;
	else if (fifo_wren & (sample_length!=(fifo_depth-1)))
		sample_length <= sample_length + 1;
		
always@ (posedge clk)
	begin
		fifo_wren1 <= fifo_wren;
		fifo_d1 <= fifo_d;
	end 
	
//srobe for fifo wren

adc_fifo_8x256	fifo_0 (
	.aclr(reset),
	.clock(clk),
	.data(fifo_d1),
	.rdreq(fifo_read_request|shifting_rd_req),
	.wrreq(fifo_wren1),
	.empty(),
	.full(fifo_full),
	.q(fifo_q),
	.usedw(fifo_usdw)
	);

endmodule 