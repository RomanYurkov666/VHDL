module spi_controller
(
//avalon mm
input avmm_reset,
input avmm_clk,
input avmm_cs,
input [1:0] avmm_addr,
input avmm_write,
input [31:0] avmm_writedata,
input avmm_read,
output reg [31:0] avmm_readdata,
//input start,
//input clock_polarity,
//input clock_phase,
//input [7:0] spi_data_length,
//input [7:0] clock_divider,
//input [31:0] transmitter_data,
//output [31:0] receiver_data,
//spi
output spi_clk,
output spi_cs_n,
output spi_mosi,
input spi_miso
);

localparam ST_IDLE = 2'd0;
localparam ST_CONFIG = 2'd1;
localparam ST_TRANSACTION = 2'd2;
localparam ST_LOAD_RX_DATA = 2'd3;

localparam CONTROL_REG_INIT = 32'h6880;

reg [31:0] control;
reg [31:0] status;
reg [31:0] tx_data;
reg [31:0] rx_data;

wire start_pulse; //from cpu
wire clock_polarity; //0
wire clock_phase; //0
wire [7:0] spi_data_length; //16
wire [7:0] clock_divider; //13

wire spi_clk_en;
wire transmitter_en;
wire receiver_en;
wire [31:0] rx_shifter_data;
wire cs_posedge;

reg [1:0] state = ST_IDLE;
reg [1:0] next_state = ST_IDLE;

reg [1:0] cs = 0;
wire load_tx_reg;
wire load_rx_reg;
wire start_transaction;
wire ready;



//settings
assign clock_polarity=control[1];
assign clock_phase=control[2];
assign spi_data_length=control[10:3];
assign clock_divider=control[18:11];
assign start_pulse = avmm_cs & avmm_write & (avmm_addr == 2'd0) & avmm_writedata[0];

assign ready = (state == ST_IDLE);

//avalon mm interface*********************************************************************
always@ (posedge avmm_clk)
		begin
			if (avmm_reset)
			begin
			control<=CONTROL_REG_INIT;
			tx_data<=0;
			rx_data<=0;
			status<=0;
			end 
			else begin
				status<={30'b0,ready};
				if (avmm_cs & avmm_write)
				case (avmm_addr)
					0: begin control<=avmm_writedata; end 
					2: begin tx_data<=avmm_writedata; end 
					default: begin  end 
				endcase 
				else if (avmm_cs & avmm_read) // 1 bus cycle delay
				case (avmm_addr)
					0: begin avmm_readdata<=control; end 
					1: begin avmm_readdata<=status; end 
					2: begin avmm_readdata<=tx_data; end 
					3: begin avmm_readdata<=rx_data; end 
					default: begin  end 
				endcase 
			if (load_rx_reg)
	        rx_data<=rx_shifter_data;
			end 
		end 
		
// core logic*****************************************************************************

assign cs_posedge=cs[1]&(~cs[0]);

always@ (posedge avmm_clk) //cs posedge detector
		begin
		cs<={spi_cs_n,cs[1]};
		end 

//fsm
always@ (posedge avmm_clk)
		if (avmm_reset)
			state<=ST_IDLE;
		else
			state<=next_state;

//next state comb logic 
always@ (state,start_pulse,cs_posedge)
		begin
		next_state=ST_IDLE;
		case (state)
			ST_IDLE: begin
				if (start_pulse) next_state=ST_CONFIG;
				else next_state=ST_IDLE;
				end
			ST_CONFIG: begin
				next_state=ST_TRANSACTION;
				end
			ST_TRANSACTION: begin
				if (cs_posedge) next_state=ST_LOAD_RX_DATA;
				else next_state=ST_TRANSACTION;
				end
			ST_LOAD_RX_DATA: begin
				next_state=ST_IDLE;
				end
			default: begin
				end 
		endcase
		end 
		
//fsm output signals
assign load_tx_reg = (state == ST_IDLE) & start_pulse;
assign load_rx_reg = (state == ST_LOAD_RX_DATA);
assign start_transaction = (state == ST_CONFIG);

		
//spi clock rate			
spi_clk_divider u0
(
	.clk(avmm_clk),
	.reset(avmm_reset),
	.divider(clock_divider),
	.slow_clk_en(spi_clk_en)
);

//spi tx shift register
spi_tx_shifter u1
(
	.clk(avmm_clk),
	.reset(avmm_reset),
	.tx_data(tx_data),
	.tx_shifter_load(load_tx_reg), 
	.tx_shift_en(transmitter_en),
	.spi_mosi(spi_mosi)
);

//spi rx shift register
spi_rx_shifter u2
(
	.clk(avmm_clk),
	.reset(avmm_reset),
	.rx_data(rx_shifter_data),
	.rx_shift_en(receiver_en),
	.spi_miso(spi_miso)
);

//timing control
spi_clk_cs_generator u3
(
	.clk(avmm_clk),
	.reset(avmm_reset),
	.slow_clk_en(spi_clk_en),
	.start(start_transaction), 
	.spi_clk_polarity(clock_polarity),
	.spi_clk_phase(clock_phase),
	.data_len(spi_data_length),
	.spi_cs(spi_cs_n),
	.spi_clk(spi_clk),
	.tx_shift_en(transmitter_en),
	.rx_shift_en(receiver_en)
);

endmodule 