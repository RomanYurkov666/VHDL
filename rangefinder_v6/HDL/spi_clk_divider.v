module spi_clk_divider
(
input clk,
input reset,
input [7:0] divider,
output slow_clk_en
);

wire divider_cntr_rst;

reg [7:0] divider_cntr = 0;

always@ (posedge clk)
		begin
		 if (reset|divider_cntr_rst)
		 divider_cntr<=0;
		 else
		 divider_cntr<=divider_cntr+1;
		end 
		
assign divider_cntr_rst = (divider_cntr == divider);
assign slow_clk_en = divider_cntr_rst;

endmodule