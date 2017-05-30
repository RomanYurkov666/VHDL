module laser_driver_avmm
(
//avalon mm slave
input avms_reset,
input avms_clk,
input avms_cs,
input [1:0] avms_addr,
input avms_write,
input [31:0] avms_writedata,
input avms_read,
output [31:0] avms_readdata,
//ref clock for driver_mode
input ref_clk,
//comparator
input comparator,
//output signals
output laser_en,
output laser_charge
);

//localparam ST_IDLE = 0b00; //Idle state
//localparam ST_PAUSE = 0b01; //Generation of pulse with fixed length and delay
//localparam ST_GENERATION = 0b10; //Generation of pulse until comparator signal 
//localparam ST_DELAY = 0b11; //Generation of pulse until comparator or max length
// 
//reg [1:0] driver_mode = 0;
//reg  start_ready = 0;
//reg [15:0] clk_divider = 0;
//reg [26:0] pulse_length = 0;
//reg [26:0] posedge_delay = 0;
//reg [26:0] negedge_delay = 0;
//
//reg [1:0] state = ST_IDLE;
//reg [1:0] next_state = ST_IDLE;
//
//reg laser_en_driver = 0;
//reg cnt_en = 0;
//reg cnt_rst = 0; 
//
//always@ (posedge ref_clk)
//	if (avms_reset)
//		state<=ST_IDLE;
//	else
//		state<=next_state;
//		
//always@ (state,start_generation,pause_completed,driver_mode,generation_complete,comparator_pulse)
//   begin
//	 next_state=ST_IDLE;
//	 case (state)
//	 ST_IDLE: begin
//		if (start_generation)
//		next_state=ST_PAUSE;
//		end
//	 ST_PAUSE: begin
//		if (pause_completed)
//		next_state=ST_GENERATION;
//		end
//	 ST_GENERATION: begin
//		if (driver_mode==0b11)
//		next_state==ST_IDLE;
//		else if ((driver_mode==0b00)&&(generation_complete))
//		next_state=ST_DELAY;
//		else if ((driver_mode==0b01)&&comparator_pulse)
//		next_state=ST_DELAY;
//		else if ((driver_mode==0b10)&&(generation_complete|comparator_pulse))
//		next_state=ST_DELAY;
//		end
//	 ST_DELAY: begin
//		if (delay_complete)
//		next_state=ST_IDLE;
//		end 
//	 default: begin
//		next_state=ST_IDLE;
//		end 
//	 endcase 
//	end 
//	
//always@ (*)
//	begin
//	 case (state)
//	 ST_IDLE: begin
//	 cnt_en=0;
//	 cnt_rst=1;
//	 laser_en_driver=0;
//	 end 
//	 ST_PAUSE: begin
//	 cnt_en=1;
//	 cnt_rst
//	 end 
//	 endcase 
//	end 






endmodule 