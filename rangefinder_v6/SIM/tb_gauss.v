`timescale 1ns/100ps
module tb_gauss();

reg clk;
reg reset;
wire [7:0] start_signal;
wire [7:0] stop_signal1;
wire [7:0] stop_signal2;
wire [7:0] stop_signal3;
wire [7:0] stop_signal4;
wire [7:0] stop_signal5;
wire [7:0] sum_signal;
reg [3:0] noise;

always #5 clk=~clk;
always #10 noise=$random;

assign sum_signal=start_signal+stop_signal1+stop_signal2+stop_signal3+stop_signal4+stop_signal5+noise;

initial 
    begin
	clk=1;
	reset=1;
	noise=0;
	#100 reset=0;
	end 


gauss_pulse #(.AMP(220),.DELAY(10)) u0
(
.clk(clk),
.reset(reset),
.signal(start_signal) 
);
gauss_pulse #(.AMP(200),.DELAY(40)) u1
(
.clk(clk),
.reset(reset),
.signal(stop_signal1) 
);
gauss_pulse #(.AMP(150),.DELAY(70)) u2
(
.clk(clk),
.reset(reset),
.signal(stop_signal2) 
);
gauss_pulse #(.AMP(120),.DELAY(100)) u3
(
.clk(clk),
.reset(reset),
.signal(stop_signal3) 
);
gauss_pulse #(.AMP(100),.DELAY(130)) u4
(
.clk(clk),
.reset(reset),
.signal(stop_signal4) 
);
gauss_pulse #(.AMP(80),.DELAY(160)) u5
(
.clk(clk),
.reset(reset),
.signal(stop_signal5) 
);

endmodule 