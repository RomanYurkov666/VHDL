module spi_clk_cs_generator
(
input clk,
input reset,
input slow_clk_en,
input start,
input spi_clk_polarity,
input spi_clk_phase,
input [7:0] data_len,
output reg spi_cs,
output reg spi_clk,
output tx_shift_en,
output rx_shift_en,
output transfer_complete
);

reg req_for_transaction = 0;
wire start_transaction;

wire spi_cycle_cntr_rst;
wire spi_cs_rst;
reg [7:0] spi_cycle_cntr = 0;
wire [7:0] spi_cycle_cntr_limit;

reg spi_clk_posedge;
reg spi_clk_negedge;		
wire valid_edge;

//Схема запуска. Формирует импульс start_transaction запуска передачи start_transaction, синхронный spi clk en
assign start_transaction=slow_clk_en&(req_for_transaction|start); 

always@ (posedge clk)
		 if (reset|slow_clk_en) //high priority
		  req_for_transaction<=0;
		 else if (start) 
		  req_for_transaction<=1;

//Схема формирования SPI CS

assign spi_cycle_cntr_limit = {data_len,1'b0} + 1'b1;
assign spi_cycle_cntr_rst = (spi_cycle_cntr >= spi_cycle_cntr_limit);
assign spi_cs_rst = (spi_cycle_cntr > spi_cycle_cntr_limit);

always@ (posedge clk)
		if (reset|spi_cs_rst)
			spi_cs<=1;
		else if (start_transaction)
			spi_cs<=0;
		 
always@ (posedge clk)
		begin
		 if (reset|spi_cs_rst)//spi_cycle_cntr_rst)
			spi_cycle_cntr<=0;
		 else if ((~spi_cs)&slow_clk_en)
			spi_cycle_cntr<=spi_cycle_cntr+1'b1;
		end 

//Схема формирования разрешения фронтов SPI CLK
		
assign valid_edge = (spi_cycle_cntr>=(1'd1-spi_clk_phase)) & (spi_cycle_cntr<(spi_cycle_cntr_limit-spi_clk_phase)) & slow_clk_en;

always@ (*)
		begin
		if (spi_clk_polarity^spi_clk_phase)
			begin
			spi_clk_posedge=(~spi_cycle_cntr[0])&valid_edge;
			spi_clk_negedge=spi_cycle_cntr[0]&valid_edge;
			end
		else
			begin
			spi_clk_posedge=spi_cycle_cntr[0]&valid_edge;
			spi_clk_negedge=(~spi_cycle_cntr[0])&valid_edge;
			end 
		end 
		
//Схема формирования SPI CLK
always@ (posedge clk)
		begin
		 if (reset|spi_cs)
			spi_clk<=spi_clk_polarity;
		 else
		    begin
			if (spi_clk_negedge)
			spi_clk<=0;
			else if (spi_clk_posedge)
			spi_clk<=1;
			end 
		end 
		
assign tx_shift_en = slow_clk_en & (~spi_cycle_cntr[0]) & (~spi_cs) & (spi_cycle_cntr<(spi_cycle_cntr_limit-1'b1));
assign rx_shift_en = slow_clk_en & spi_cycle_cntr[0] & (~spi_cs) & (spi_cycle_cntr<(spi_cycle_cntr_limit-1'b1));


endmodule 