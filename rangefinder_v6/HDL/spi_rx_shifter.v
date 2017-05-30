module spi_rx_shifter
(
input clk,
input reset,
output [31:0] rx_data,
input rx_shift_en,
input spi_miso
);

reg [31:0] rx_shifter = 0; 

always@ (posedge clk)
		begin
		 if (reset)
		 rx_shifter<=0;
		 else 
			begin
			if (rx_shift_en)
			rx_shifter<={rx_shifter[30:0],spi_miso};
			end 
		end 
		
assign rx_data = rx_shifter;

endmodule