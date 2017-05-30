`timescale 1ns/100ps
module tb_comp_reset_gen();

reg clk = 1;
reg reset = 0;
reg impulse = 0;

always #5
	clk<=~clk;
	
initial	
	begin
		#200
		reset = 0;
		#207
		impulse = 1;
		#5
		impulse = 0;
	end 
	
comp_reset_generator u0
(
	.reset(reset),
	.ref_clk(clk),
	.comp_out(impulse),
	.rst_driver()
);

endmodule 