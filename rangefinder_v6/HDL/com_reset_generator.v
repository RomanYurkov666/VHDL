//ÐÐ¾ÑÐ»Ðµ Ð¿ÑÐ¸ÑÐ¾Ð´Ð° Ð¸Ð¼Ð¿ÑÐ»ÑÑÐ° Ñ ÐºÐ¾Ð¼Ð¿Ð°ÑÐ°ÑÐ¾ÑÐ°, Ð¿Ð¾Ð´Ð¾Ð¶Ð´Ð°ÑÑ 100 Ð½Ñ Ð¸ Ð¿Ð¾ÑÐ»Ðµ Ð²ÑÐ´Ð°ÑÑ Ð¸Ð½Ð²ÐµÑÑÐ½ÑÐ¹ Ð¸Ð¼Ð¿ÑÐ»ÑÑ ÑÐ¸ÑÐ¸Ð½Ð¾Ð¹ 20 Ð½Ñ
module comp_reset_generator
(
	input reset,
	input ref_clk,
	input comp_out,
	output rst_driver
);

parameter PULSE_LEN = 4;
parameter PULSE_DELAY = 20;

localparam st_idle = 2'h0;
localparam st_delay = 2'h1;
localparam st_active = 2'h2;

reg [4:0] cnt = 5'h0;
reg [1:0] state = st_idle;
reg [1:0] next_state = st_idle;
reg driver = 0;

wire comp_resync;
wire start, start_pulse, stop;
wire cntr_en, cntr_rst;
wire driver_set, driver_reset;

assign start = comp_resync;
assign start_pulse = (cnt == (PULSE_DELAY - 1));
assign stop = (cnt == (PULSE_LEN - 1));
assign cntr_rst = (state != next_state);
assign cntr_en = (state == st_delay) | (state == st_active);
assign driver_set = (next_state == st_active) & (state == st_delay);
assign driver_reset = (next_state == st_idle) & (state == st_active);

pulse_cross_domain u0
(
	.pulse_in(comp_out), 
	.clk_out(ref_clk),
	.pulse_out(comp_resync)
);


//fsm
always@ (posedge ref_clk)
	if (reset)
		state<=st_idle;
	else
		state<=next_state;

//fsm next state
always@ (state, start, start_pulse, stop)
	begin
		next_state = st_idle;
		case (state)
		st_idle: begin
			if (start)
				next_state=st_delay;
			else
				next_state=st_idle;
		end
		st_delay: begin
			if (start_pulse)
				next_state=st_active;
			else
				next_state=st_delay;
		end
		st_active: begin
			if (stop)
				next_state=st_idle;
			else
				next_state=st_active;
		end
		default: begin
			next_state=st_idle;
		end
		endcase 
	end 
	
always@ (posedge ref_clk)
	begin
		if (cntr_rst)
			cnt <= 5'h0;
		else if (cntr_en)
			cnt <= cnt + 1'b1;
	end 
	
always@ (posedge ref_clk)
	if (driver_reset)
		driver <= 1'b0;
	else if (driver_set)
		driver <= 1'b1;
		
assign rst_driver = ~driver;

endmodule 
