module spi_tx_shifter
(
input clk,
input reset,
input [31:0] tx_data,
input tx_shifter_load,
input tx_shift_en,
output spi_mosi
);

reg [32:0] tx_shifter = 0; //width more than 32 bit for 1st cycle

always@ (posedge clk)
		begin
		 if (reset)
		 tx_shifter<=0;
		 else 
			begin
			if (tx_shifter_load)
			tx_shifter<={1'b0,tx_data};
			else if (tx_shift_en)
			tx_shifter<={tx_shifter[31:0],tx_shifter[31]};
			end 
		end 
		
assign spi_mosi = tx_shifter[32];

endmodule 