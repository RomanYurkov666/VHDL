`timescale 1ns / 1ps
module cross_old(
    input clk_a,
    input clk_b,
    input imp_a,
    output imp_b
    );

	wire rst;

	reg ff_1 = 1'b0;
	reg ff_2 = 1'b0;
	reg ff_3 = 1'b0;

always @(posedge clk_a or posedge rst)
	if (rst)
		ff_1 <= 1'b0;
	else if (imp_a)
		ff_1 <= 1'b1;

always @(posedge clk_b)
	ff_2 <= ff_1;

always @(posedge clk_b)
	ff_3 <= (~ff_3 & ff_2);

assign rst = ff_3;
assign imp_b = ff_3;

endmodule
