module memory_master
(
input reset, //reset 
input ref_clk, //reference clk
input start,//start pulse for recording
input stop, //stop pulse for recording
input [7:0] stop_delay, //delay from stop pulse to the end of recording
input [12:0] coarse_counter,
//avalon mm master
output av_cs,
output [7:0] av_addr,
output av_write,
//Status signals
output [7:0] ram_ptr, //current value of RAM pointer (memory master bus)
output stop_detected, //stop pulse detected, flag
output buffer_full, //process of recording was stoped
output [7:0] sample_size, //count of samples recorded after start-pulse
output [12:0] pulse_abs_coord //absolute position of the pulse
);

parameter RAM_SIZE = 256; //size of external RAM
parameter ADDR_BUS = 8; //size of address bus (eq to RAM size)

//status registers
reg [ADDR_BUS-1:0] ram_ptr_reg = 0;
reg stop_detected_reg = 0;
reg buffer_full_reg = 0;
reg [ADDR_BUS-1:0] sample_size_reg = 0;
reg [12:0] pulse_abs_coord_reg = 0;

//internal registers and signals
reg write_strobe = 0;
reg [ADDR_BUS-1:0] delay_cnt = 0;
reg delay_cnt_strobe = 0;
wire delay_cnt_stop;
wire ram_ptr_reset;
reg [ADDR_BUS-1:0] samp_size_cnt = 0;
wire sample_size_cnt_full;
reg sample_size_strobe = 0;
reg write_strobe1 = 0;
wire recording_complete;

//ports
assign av_cs=write_strobe;
assign av_write=write_strobe;
assign av_addr=ram_ptr_reg;
assign ram_ptr=ram_ptr_reg;
assign stop_detected=stop_detected_reg;
assign buffer_full=buffer_full_reg;
assign sample_size=sample_size_reg;
assign pulse_abs_coord=pulse_abs_coord_reg;

//internal comb
assign delay_cnt_stop=(delay_cnt==stop_delay);
assign ram_ptr_reset=(ram_ptr_reg==(RAM_SIZE-1));
assign sample_size_cnt_full=(samp_size_cnt==RAM_SIZE-1);
assign recording_complete=write_strobe1&(~write_strobe);

//absolute position of the pulse
always@ (posedge ref_clk)
        begin
        if (reset) pulse_abs_coord_reg<=0;
		else if (stop) pulse_abs_coord_reg<=coarse_counter;
        end 		
		
//write strobe generation
always@ (posedge ref_clk)
         begin
		  if (reset)
		      begin
			  write_strobe<=0;
			  delay_cnt_strobe<=0;
			  delay_cnt<=0;
			  end 
          else 
              begin
		       //write strobe
		       if (delay_cnt_stop) write_strobe<=0;
		       else if (start) write_strobe<=1;
		       //delay cnt strobe
		       if (delay_cnt_stop) delay_cnt_strobe<=0;
		       else if (stop) delay_cnt_strobe<=1; 
		       //delay counter
		       if (delay_cnt_stop) delay_cnt<=0;
               else if (stop|delay_cnt_strobe) delay_cnt<=delay_cnt+1;	
              end 	
		  write_strobe1<=write_strobe;
		 end 

//ram_ptr control		 
always@ (posedge ref_clk)
         begin
		  if (reset|ram_ptr_reset) ram_ptr_reg<=0;
		  else if (write_strobe) ram_ptr_reg<=ram_ptr_reg+1;
		 end 

//sample size control
always@ (posedge ref_clk)
         begin
		  if (stop) sample_size_strobe<=0;
		  else if (start) sample_size_strobe<=1;
		  
		  if (stop) 
		      begin
			  samp_size_cnt<=0;
			  sample_size_reg<=samp_size_cnt;
			  end 
		  else if (sample_size_strobe&(~sample_size_cnt_full))
		     begin
			 samp_size_cnt<=samp_size_cnt+1;
			 end
		 end
		 
//stop detector
always@ (posedge ref_clk)
         begin
		  if (reset) stop_detected_reg<=0;
		  else if (stop) stop_detected_reg<=1;
		 end 

//buffer full		 
always@ (posedge ref_clk)
         begin
          if (reset) buffer_full_reg<=0;
		  else if (recording_complete) buffer_full_reg<=1;
         end		 	 
endmodule 