`timescale 1ns/100ps
module tb_recording_channel();

reg reset = 1;
reg clk = 1;
reg [7:0] adc_data = 0;
reg start_pulse = 0;
reg start_pulse = 0;
reg [12:0] abs_cntr = 0;
reg fifo_rdreq = 0;

always #5
	clk <= ~clk;

always #10000
	begin
	reset = 1;
	#10
	reset = 0;
	#200
	start_pulse = 1;
	#10
	start_pulse = 0;
	#4000
	stop_pulse = 1;
	#10
	stop_pulse = 0;
	#300
	fifo_rdreq = 1;
	#2560
	fifo_rdreq = 0;
	end 
	
always #10
	adc_data <= adc_data + 1;
	
always #10
	if (reset)
		abs_cntr = 0;
	else 
		abs_cntr = abs_cntr + 1;
	




recording_channel u0
(
	.reset(reset), 				//aclr for fifo
	.clk(clk), 					//fast clk (adc domain)
	.fifo_d(adc_data),			//data for writing in fifo 
	.start_pulse(start_pulse),			//start for recording channel
	.stop_pulse(stop_pulse),			//stop recording (with optional delay)
	.stop_recording(), 		//if there were no comp pulse, but its neccessary to stop recording
	.stop_delay(64), 	//delay in clk cycles
	.abs_counter(abs_cntr),	//timestamp from counter
	.fifo_read_request(), 	//request for reading from fifo
	.echo_pulse_detected(),	//pulse detected
	.sample_length(), //length of sample, stored in fifo 
	.fifo_usdw(),		//current cnt of words in fifo (address for writing in buf RAM)
	.fifo_q(),		//fifo .(
	.timestamp()		//stop pulse timestamp
);

endmodule 