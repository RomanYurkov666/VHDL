module controller_spi
(
//avalon mm
input avmm_reset,
input avmm_clk,
input avmm_cs,
input [2:0] avmm_addr,
input avmm_write
input [31:0] avmm_writedata,
input avmm_read,
output reg [31:0] avmm_readdata,
//spi
output reg spi_clk,
output reg spi_cs_n,
output spi_mosi,
input spi_miso
);

localparam ST_IDLE = 3'd0;
localparam ST_CONFIGURATION = 3'd1;
localparam ST_WAIT = 3'd2;
localparam ST_TRANSACTION = 3'd3;
localparam ST_LOAD_RX_DATA = 3'd4;

//*****************************************************************
//*****************************************************************
//control registers
reg [5:0] data_length = 6'd0; //Длина передаваемого слова
reg [7:0] clk_divider = 8'd255; //Предделитель тактового сигнала
reg clk_polarity = 0; //Полярность выходного тактового сигнала
reg clk_phase = 0; //Фаза выходного тактового сигнала
reg [31:0] tx_data = 0; //Передаваемое слово
reg [31:0] rx_data = 0; //Принятое слово
//*****************************************************************
//*****************************************************************

reg [2:0] state = ST_IDLE;
reg [2:0] next_state;

reg [7:0] spi_cycle_cntr = 0;
reg tx_shifter_load_en = 0;
reg tx_shift_en = 0;
reg rx_shift_en = 0;
reg rx_load_data = 0;
reg spi_clk_posedge_en = 0;
reg spi_clk_negedge_en = 0;

reg [31:0] tx_shifter = 0;
reg [31:0] rx_shifter = 0;

reg [6:0] 

wire start_transaction; //Импульс запуска работы контроллера, формируется при записи процессором бита START

//Схема формирования сигнала разрешения для формирования фронтов SPI_CLK
reg [7:0] slow_clk_div_cnt = 0;
wire slow_clk_div_cnt_rst;
wire slow_clk_div_cnt_en;
wire slow_clk_edge_en;

assign slow_clk_div_cnt_rst = (slow_clk_div_cnt == clk_divider);
assign slow_clk_div_cnt_en = ~slow_clk_div_cnt_rst;
assign slow_clk_edge_en = slow_clk_div_cnt_rst;

always@ (posedge avmm_clk)
		begin
			if (slow_clk_div_cnt_rst)
			slow_clk_div_cnt<=0;
			else if (slow_clk_div_cnt_en)
			slow_clk_div_cnt<=slow_clk_div_cnt+1;
		end 

//Автомат управления **************************************************************************************
always@ (posedge avmm_clk)
		begin
		 if (avmm_reset)
		 state<=ST_IDLE;
		 else
		 state<=next_state;
		end 

//Формирование следующего состояния автомата
always@ (start_transaction,slow_clk_edge_en,last_spi_cycle)
		begin
		next_state=ST_IDLE;
		case (state)
			ST_IDLE: begin
			if (start_transaction) 
			next_state=ST_CONFIGURATION;
			else
			next_state=ST_IDLE;
			end
			ST_CONFIGURATION: begin
			next_state=ST_WAIT;
			end 
			ST_WAIT: begin
			if (slow_clk_edge_en)
			next_state=ST_TRANSACTION;
			else
			next_state=ST_WAIT;
			end
			ST_TRANSACTION: begin
			if (spi_cycle_cntr_rst)
			next_state=ST_LOAD_RX_DATA;
			else
			next_state=ST_TRANSACTION;
			end 
			ST_LOAD_RX_DATA: begin
			next_state=ST_IDLE;
			end
			default: begin
			next_state=ST_IDLE;
			end 
		endcase 
		end 

reg load_new_settings = 0;		
reg spi_signals_en = 0;
reg load_rx_data = 0;
		
//Выходные сигналы автомата 		
always@ (*)
		begin
		 case (next_state)
			ST_IDLE: begin
            load_new_settings=0;
			spi_signals_en=0;
			load_rx_data=0;
			end
			ST_CONFIGURATION: begin
            load_new_settings=1;
			spi_signals_en=0;
			load_rx_data=0;
			end 
			ST_WAIT: begin
			load_new_settings=0;
			spi_signals_en=0;
			load_rx_data=0;
			end
			ST_TRANSACTION: begin
			load_new_settings=0;
			spi_signals_en=1;
			load_rx_data=0;
			end 
			ST_LOAD_RX_DATA: begin
			load_new_settings=0;
			spi_signals_en=0;
			load_rx_data=1;
			end
			default: begin
			load_new_settings=0;
			spi_signals_en=0;
			load_rx_data=0;
			end 
		 endcase 
		end

//************************************************************************************

wire spi_cycle_cntr_rst;
wire slow_clk_edge_en;
wire [7:0] spi_cycle_cntr_lim;
wire [7:0] cycle_cntr_limit_buf;

assign cycle_cntr_limit_buf = data_length + 1'b1;
assign spi_cycle_cntr_lim = {cycle_cntr_limit_buf,1'b0};

assign spi_cycle_cntr_rst = (spi_cycle_cntr == spi_cycle_cntr_lim);

always@ (posedge avmm_clk)
		begin
		 if (spi_cycle_cntr_rst)
		 spi_cycle_cntr<=0;
		 else if (slow_clk_edge_en)
		 spi_cycle_cntr<=spi_cycle_cntr+1;
		end 

//*****************************************************************************************************
//Формирование сигналов разрешения фронтов тактового сигнала
wire valid_edge;
assign valid_edge = (spi_cycle_cntr>(1'd1-clk_phase)) & (spi_cycle_cntr<(spi_cycle_cntr_lim-clk_phase)) & slow_clk_edge_en;

always@ (*)
		begin
			if (clk_polarity)
			begin
				if (clk_phase)
				begin
				spi_clk_posedge_en=(~spi_cycle_cntr[0])&valid_edge;
				spi_clk_negedge_en=spi_cycle_cntr[0]&valid_edge;
				end
				else
				begin
				spi_clk_posedge_en=spi_cycle_cntr[0]&valid_edge;
				spi_clk_negedge_en=(~spi_cycle_cntr[0])&valid_edge;
				end 
			end
			else
			begin
				if (clk_phase)
				begin
				spi_clk_posedge_en=spi_cycle_cntr[0]&valid_edge;
				spi_clk_negedge_en=(~spi_cycle_cntr[0])&valid_edge;
				end
				else
				begin
				spi_clk_posedge_en=(~spi_cycle_cntr[0])&valid_edge;
				spi_clk_negedge_en=spi_cycle_cntr[0]&valid_edge;
				end 
			end 
		end 

//*****************************************************************************************************

wire spi_cs_reset;
wire spi_cs_set;
wire spi_clk_set;
wire spi_clk_reset;

assign spi_mosi=tx_shifter[31];

assign spi_cs_reset = (next_state==ST_TRANSACTION);
assign spi_cs_set = (next_state==ST_LOAD_RX_DATA);
assign spi_clk_set = spi_clk_posedge_en;
assign spi_clk_reset = spi_clk_negedge_en;

//spi logic
always@ (posedge avmm_clk)
		begin
		 //spi chip select
		 if (spi_cs_reset)
		 spi_cs_n<=0;
		 else if (spi_cs_set)
		 spi_cs_n<=1;
		 //spi clock
		 if (spi_clk_reset)
		 spi_clk<=0;
		 else if (spi_clk_set)
		 spi_clk<=1;
		end 
		
endmodule 