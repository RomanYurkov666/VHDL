`timescale 1ns/100ps
module tb_pulse_gen();

reg clk = 1;
reg reset = 1;
reg cs = 0;
reg [2:0] addr = 0;
reg write = 0;
reg [31:0] wdata = 0;

always #5
	clk<=~clk;
	
initial
	begin
	#100
	reset<=0;
	#100
	cs<=1;
	write<=1;
	addr<=1; //start
	wdata<=32'h800A000A;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=2; //stop 0
	wdata<=32'h800A0014;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=3; //stop 1
	wdata<=32'h800A0032;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=4; //stop 2
	wdata<=32'h800A0064;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=5; //stop 3
	wdata<=32'h800A00C8;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=6; //stop 4
	wdata<=32'h800A01F4;
	#10
	cs<=0;
	write<=0;
	#10
	cs<=1;
	write<=1;
	addr<=0; //control
	wdata<=32'h00000001;
	#10
	cs<=0;
	write<=0;
	end 

test_pulse_generator u0
(
.avmm_reset(reset),
.avmm_clk(clk),
.avmm_cs(cs),
.avmm_addr(addr),
.avmm_write(write),
.avmm_writedata(wdata),
.avmm_read(),
.avmm_readdata(),
.start_pulse(),
.stop_pulse()
);

endmodule 