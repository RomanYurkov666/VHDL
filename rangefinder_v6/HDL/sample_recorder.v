module sample_recorder
(
	//avalon clk/reset
	input mm_clk,
	input mm_reset,
	//avalon mm control port
	input avsc_cs,
	input [3:0] avsc_addr,
	input avsc_write,
	input [31:0] avsc_writedata,
	input avsc_read,
	output reg [31:0] avsc_readdata,
	//avalon mm data port (RAM)
	input avsd_cs,
	input [5:0] avsd_addr,
	input avsd_read,
	output reg [31:0] avsd_readdata,
	//external signals
	input adc_clk,
	input [7:0] adc_data,
	input comparator
);

//fsm states and registers***********************************************************************************************
localparam st_idle = 					3'h0; //module do nothing; fifo's are empty; cpu can only read memory loaded before 
localparam st_recording = 				3'h1; //absolute counter run, module waiting for echo pulse and writing current fifo;
localparam st_ready = 					3'h2; //recording completed
localparam st_copy_to_mem = 			3'h3; //Data copying to out RAM

reg [2:0] state = st_idle;
reg [2:0] next_state = st_idle;

//cpu signals for fsm and submodules*************************************************************************************
wire cpu_start_recording, cpu_stop_recording, cpu_start_loading_to_mem, cpu_complete; //0..2 bits of control
wire start_recording, stop_recording, start_loading_to_mem, complete; //0..2 bits of control

assign cpu_start_recording = avsc_cs & avsc_write & (avsc_addr == 1) & (avsc_writedata[0]);
assign cpu_stop_recording = avsc_cs & avsc_write & (avsc_addr == 1) & (~avsc_writedata[0]);

assign cpu_start_loading_to_mem = avsc_cs & avsc_write & (avsc_addr == 0) & (avsc_writedata[0]);
assign cpu_complete = avsc_cs & avsc_write & (avsc_addr == 0) & (avsc_writedata[1]);

//module control interface***********************************************************************************************
wire [2:0] active_record_channel; //6:4 bits 
wire trigger_source; //3 bit 
wire recording_is_active; //0 bit 
wire [7:0] trigger_threshold; //14..7 bits
wire trigger_direction; //15 bit 
wire [7:0] recording_delay; //8 bit

reg [31:0] control_0 = 32'h0;
reg [31:0] control_1 = 32'h0;

assign active_record_channel = control_0[5:3];
assign trigger_source = control_0[2];
assign recording_is_active = control_0[0];
assign trigger_threshold = control_0[13:6];
assign trigger_direction = control_0[14];
assign recording_delay = control_0[22:15];

//reset signal from avalon mm resync************************************************************************************
reg reset = 0;

//trigger source signals ***********************************************************************************************
reg echo_pulse_detected = 0; //mux output (comb logic)
wire comp_pulse; //resync comparator pulse 
wire trigger_gen_out; //output 

//timestamp counter signals*********************************************************************************************
wire [12:0] fine_ts_counter;
wire [7:0] coarse_ts_counter;

//recording channel selector signals************************************************************************************
wire [5:0] stop_pulses;

//channel switch signals************************************************************************************************
wire [5:0] channel_read_requests;

//recording channels signals *******************************************************************************************
wire [7:0] fifo_0_q;
wire [7:0] fifo_0_usdw;
wire [7:0] fifo_1_q;
wire [7:0] fifo_1_usdw;
wire [7:0] fifo_2_q;
wire [7:0] fifo_2_usdw;
wire [7:0] fifo_3_q;
wire [7:0] fifo_3_usdw;
wire [7:0] fifo_4_q;
wire [7:0] fifo_4_usdw;
wire [7:0] fifo_5_q;
wire [7:0] fifo_5_usdw;
wire [7:0] fifo_q_to_dma;
wire [7:0] fifo_usdw_to_dma;

wire [21:0] channel_0_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected
wire [21:0] channel_1_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected
wire [21:0] channel_2_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected
wire [21:0] channel_3_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected
wire [21:0] channel_4_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected
wire [21:0] channel_5_info; //21..9 - timestamp, 8:1 - len, 0 - pulse detected

//dma signals*************************************************************************************************************
wire fifo_read_req_from_dma;
wire dma_busy, dma_ready;
wire [7:0] ram_address;
wire [7:0] ram_data;
wire ram_wren;

//*************************************************************************************************************************
//submodules/core**********************************************************************************************************
//*************************************************************************************************************************

//reset resync for all modules in adc clock domain
always@ (posedge adc_clk)
	reset <= mm_reset;
	
//resync cpu pulses to adc clock domain
cross_domain cross_dom_0
(
	.clk_in(mm_clk),
	.pulse_in(cpu_start_recording),
	.clk_out(adc_clk),
	.pulse_out(start_recording)
);

cross_domain cross_dom_1
(
	.clk_in(mm_clk),
	.pulse_in(cpu_stop_recording),
	.clk_out(adc_clk),
	.pulse_out(stop_recording)
);

cross_domain cross_dom_2
(
	.clk_in(mm_clk),
	.pulse_in(cpu_start_loading_to_mem),
	.clk_out(adc_clk),
	.pulse_out(start_loading_to_mem)
);

cross_domain cross_dom_3
(
	.clk_in(mm_clk),
	.pulse_in(cpu_complete),
	.clk_out(adc_clk),
	.pulse_out(complete)
);

//resync of external comparator pulse to adc clock domain
pulse_cross_domain comp_resync
(
	.pulse_in(comparator),
	.clk_out(adc_clk),
	.pulse_out(comp_pulse) //adc clock domain, 1 clock cycle width
);

//generation of trigger pulse by adc sample (threshold)
trigger_pulse_gen #(.DELAY(10)) trigger_gen
(
	.clk(adc_clk),
	.sample(adc_data),
	.threshold(trigger_threshold),
	.direction(trigger_direction),
	.trigger(trigger_gen_out) //adc clock domain, 1 clock cycle width
);
	
//multiplexer for start pulse sources
always@ (trigger_source)
begin
	echo_pulse_detected=1'b0;
	case (trigger_source)
	1'b0: begin echo_pulse_detected=comp_pulse; end 
	2'b1: begin echo_pulse_detected=trigger_gen_out; end
	endcase
end 

//timestamp counter 
timestamp_cntr tmstmp
(
	.reset(complete|reset),
	.clk(adc_clk),
	.start(start_recording),
	.stop(stop_recording),
	.fine_cnt(fine_ts_counter),
	.coarse_cnt(coarse_ts_counter)
);

//recording channel selector
record_buffer_selector buf_sel
(
	.reset(complete|reset),
	.clk(adc_clk),
	.start_rec(start_recording),
	.pulse(echo_pulse_detected),
	.stop_pulse(stop_pulses)
);


//dma
simple_dma dma
(
	.clk(adc_clk), 
	.reset(complete|reset), 
	.start_transfer(start_loading_to_mem), 
	.busy(dma_busy), 
	.ready(dma_ready),
	.fifo_q(fifo_q_to_dma), 
	.fifo_usdw(fifo_usdw_to_dma),
	.fifo_rdreq(fifo_read_req_from_dma),
	.ram_addr(ram_address), 
	.ram_d(ram_data),
	.ram_wren(ram_wren) 
);

//switch for dma <=> channels mux/demux
rec_channel_switch ch_switch
(
	.reset(complete|reset),
	.clk(adc_clk),
	.active_channel(active_record_channel),
	.dma_rd_req(fifo_read_req_from_dma),
	.ch_read_req(channel_read_requests),
	.fifo_0_q(fifo_0_q),
	.fifo_0_usdw(fifo_0_usdw),
	.fifo_1_q(fifo_1_q),
	.fifo_1_usdw(fifo_1_usdw),
	.fifo_2_q(fifo_2_q),
	.fifo_2_usdw(fifo_2_usdw),
	.fifo_3_q(fifo_3_q),
	.fifo_3_usdw(fifo_3_usdw),
	.fifo_4_q(fifo_4_q),
	.fifo_4_usdw(fifo_4_usdw),
	.fifo_5_q(fifo_5_q),
   .fifo_5_usdw(fifo_5_usdw),
	.fifo_q(fifo_q_to_dma),
	.fifo_usdw(fifo_usdw_to_dma)
);

//channel 0
recording_channel chan_0
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[0]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[0]), 	
	.echo_pulse_detected(channel_0_info[0]),	
	.sample_length(channel_0_info[8:1]),
	.fifo_usdw(fifo_0_usdw),		
	.fifo_q(fifo_0_q),		
	.timestamp(channel_0_info[21:9])		
);

//channel 1
recording_channel chan_1
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[1]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[1]), 	
	.echo_pulse_detected(channel_1_info[0]),	
	.sample_length(channel_1_info[8:1]),
	.fifo_usdw(fifo_1_usdw),		
	.fifo_q(fifo_1_q),		
	.timestamp(channel_1_info[21:9])		
);

//channel 2
recording_channel chan_2
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[2]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[2]), 	
	.echo_pulse_detected(channel_2_info[0]),	
	.sample_length(channel_2_info[8:1]),
	.fifo_usdw(fifo_2_usdw),		
	.fifo_q(fifo_2_q),		
	.timestamp(channel_2_info[21:9])		
);

//channel 3
recording_channel chan_3
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[3]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[3]), 	
	.echo_pulse_detected(channel_3_info[0]),	
	.sample_length(channel_3_info[8:1]),
	.fifo_usdw(fifo_3_usdw),		
	.fifo_q(fifo_3_q),		
	.timestamp(channel_3_info[21:9])		
);

//channel 4
recording_channel chan_4
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[4]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[4]), 	
	.echo_pulse_detected(channel_4_info[0]),	
	.sample_length(channel_4_info[8:1]),
	.fifo_usdw(fifo_4_usdw),		
	.fifo_q(fifo_4_q),		
	.timestamp(channel_4_info[21:9])		
);

//channel 5
recording_channel chan_5
(
	.reset(complete|reset), 				
	.clk(adc_clk), 					
	.fifo_d(adc_data),			
	.start_pulse(start_recording),		
	.stop_pulse(stop_pulses[5]),			
	.stop_recording(stop_recording), 		
	.stop_delay(recording_delay), 	
	.abs_counter(fine_ts_counter),	
	.fifo_read_request(channel_read_requests[5]), 	
	.echo_pulse_detected(channel_5_info[0]),	
	.sample_length(channel_5_info[8:1]),
	.fifo_usdw(fifo_5_usdw),		
	.fifo_q(fifo_5_q),		
	.timestamp(channel_5_info[21:9])		
);

//RAM
adc_ram_2_ports_8x256	cpu_ram (
	.data (ram_data),
	.rdaddress (avsd_addr),
	.rdclock (mm_clk),
	.wraddress (ram_address),
	.wrclock (adc_clk),
	.wren (ram_wren),
	.q (avsd_readdata)
	);


//fsm**********************************************************************************
always@ (posedge adc_clk)
	if (reset)
		state <= st_idle;
	else
		state <= next_state;
		
always@ (posedge adc_clk)
	begin
		next_state=st_idle;
		case (state)
		st_idle: begin 
			if (start_recording)
				next_state=st_recording;
			else 
				next_state=st_idle;
		end 
		st_recording: begin 
			if (stop_recording)
				next_state=st_ready;
			else
				next_state=st_recording;
		end 
		st_ready: begin 
			if (start_loading_to_mem)
				next_state=st_copy_to_mem;
			else if (complete)
				next_state=st_idle;
			else
				next_state=st_ready;
		end
		st_copy_to_mem: begin
			if (dma_ready)
				next_state=st_ready;
			else
				next_state=st_copy_to_mem;
		end
		endcase
	end 


//avalon control interface	
always@ (posedge mm_clk)
		begin
			if (mm_reset)
				begin
					control_0 <=0;
					control_1 <=0;
				end 
			else if (avsc_cs & avsc_write)
				begin
					case (avsc_addr)
					0: begin control_0 <= avsc_writedata; end 
					1: begin control_1 <= avsc_writedata; end
					default: begin  end 
					endcase 
				end 
			else if (avsc_cs & avsc_read)
				begin
					case (avsc_addr)
					0: begin avsc_readdata <= control_0; end
					1: begin avsc_readdata <= control_1; end 
					2: begin avsc_readdata <= {29'h0,state}; end
					3: begin avsc_readdata <= channel_0_info; end 
					4: begin avsc_readdata <= channel_1_info; end 
					5: begin avsc_readdata <= channel_2_info; end 
					6: begin avsc_readdata <= channel_3_info; end 
					7: begin avsc_readdata <= channel_4_info; end 
					8: begin avsc_readdata <= channel_5_info; end
					default: begin avsc_readdata <= 32'habcdef90; end 
					endcase 
				end 
		end 

endmodule 