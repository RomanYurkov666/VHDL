`timescale 1ns/100ps
stepper_controller_tb();

reg clk = 1;
reg reset;

reg write;
reg [31:0] writedata;
reg cs;
reg [1:0] addr;

always #5 clk<=~clk;

initial begin
write = 0;
writedata = 0;
cs = 0;
addr = 0;
reset = 1;
#100
reset = 0;
#100
writedata = 100;
write = 1;
cs = 1;
addr = 2;
#10
writedata = 0;
write = 0;
cs = 0;
addr = 0;
#20
writedata = 32'h5;
write = 1;
cs = 1;
addr = 0;
#10
writedata = 0;
write = 0;
cs = 0;
addr = 0;
#500
writedata = 32'h0;
write = 1;
cs = 1;
addr = 0;
#10
writedata = 0;
write = 0;
cs = 0;
addr = 0;
#500
writedata = 32'h10;
write = 1;
cs = 1;
addr = 3;
#1000
writedata = 0;
write = 0;
cs = 0;
addr = 0;
end 


stepper_controller u0
(
//avalon
	.avs_clk(clk),
	.avs_reset(),
	.avs_cs(),
	.avs_address(),
	.avs_write(),
	.avs_writedata(),
	.avs_read(),
	.avs_readdata(),
	.output step(),
	.dir()
);

endmodule 