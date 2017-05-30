`timescale 1ns/100ps
module tb_mem_master();

reg reset;
reg clk;
reg start;
reg stop;
reg [7:0] stop_delay;
reg [12:0] cntr;

wire av_cs;
wire av_write;
wire [7:0] av_addr;
wire [7:0] ram_ptr;
wire stop_detected;
wire buffer_full;
wire [7:0] sample_size;
wire [12:0] pulse_abs_coord;


initial 
     begin
	 reset=1;
	 clk=1;
	 start=0;
	 stop=0;
	 stop_delay=16;
	 cntr=0;
	 
	 #100
	 reset=0;
	 #50
	 start<=1;
	 #10
	 start<=0;
	 #5000
	 stop<=1;
	 #10
	 stop<=0;
	 #1000
	 reset<=1;
	 #10 
	 stop_delay<=32;
	 reset<=0;
	 #100
	 start<=1;
	 #10
	 start<=0;
	 #1500
	 stop<=1;
	 #10
	 stop<=0;
	 #500
	 reset<=1;
	 end 

	 
always #5 clk<=~clk;
always #10 cntr<=cntr+1;

memory_master u0
(
.reset(reset), //reset 
.ref_clk(clk), //reference clk
.start(start),//start pulse for recording
.stop(stop), //stop pulse for recording
.stop_delay(stop_delay), //delay from stop pulse to the end of recording
.coarse_counter(cntr),
//avalon mm master
.av_cs(av_cs),
.av_addr(av_addr),
.av_write(av_write),
//Status signals
.ram_ptr(ram_ptr), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected), //stop pulse detected, flag
.buffer_full(buffer_full), //process of recording was stoped
.sample_size(sample_size), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord) //absolute position of the pulse
);

endmodule 