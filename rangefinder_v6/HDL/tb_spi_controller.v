`timescale 1ns/100ps
module tb_spi_controller ();

reg clk = 1;
reg reset = 1;

reg write = 0;
reg cs = 0;
reg [1:0] addr = 0;
reg [31:0] wdata = 0;

wire line;

always #5
	clk<=~clk;
	
initial
	begin
	 #100
	 reset=0;
	 #20
	 //write tx data
	 write=1;
	 cs=1;
	 addr=2;
	 wdata=32'h5A123456;
     #10
	 write=0;
	 cs=0;
     #50
	 write=1;
	 cs=1;
	 addr=0;
	 wdata=32'h6881;
     #10
	 write=0;
	 cs=0;	 
	end 

spi_controller u0
(
//avalon mm
.avmm_reset(reset),
.avmm_clk(clk),
.avmm_cs(cs),
.avmm_addr(addr),
.avmm_write(write),
.avmm_writedata(wdata),
.avmm_read(),
.avmm_readdata(),
.spi_clk(),
.spi_cs_n(),
.spi_mosi(line),
.spi_miso(line)
);

endmodule 