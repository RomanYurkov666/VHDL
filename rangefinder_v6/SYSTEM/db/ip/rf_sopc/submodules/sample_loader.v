module sample_loader
(
input reset,     //global reset
input adc_clk,   //adc clock out 
input [7:0] adc_sample, //adc bus
input direct_comp, //async comparator out
input adaptive_comp, //async adaptive comparator  
output tdc_strobe,
//avalon slave
input avs_reset,
input avs_clk,
input avs_cs,
input [3:0] avs_addr,
input avs_write,
input [31:0] avs_writedata,
input avs_read,
output reg [31:0] avs_readdata,
//avalon master ---> RAM buffers (6 x 256 bytes)
output avm_clk,
output avm_reset,
output [7:0] avm_writedata,
output [5:0] avm_cs, //CSs for 6 RAM
output [5:0] avm_write, //write strobes for 6 RAM
output [7:0] avm0_addr,
output [7:0] avm1_addr,
output [7:0] avm2_addr,
output [7:0] avm3_addr,
output [7:0] avm4_addr,
output [7:0] avm5_addr //addresses for 6 RAM
);

//interface registers
reg [31:0] control = 0; // 0bit - module enable
reg [7:0] comp_pulse_cnt = 0; //counter for direct comparator pulses
reg [12:0] absolute_counter = 0;

//internal signals 
wire comp_pulse;
reg [5:0] mem_master_selector = 6'b000001;
wire [5:0] start_bus;
wire [5:0] stop_bus;
wire cpu_start_command;
wire start_rec_cpu_domain;
wire recording_flag;
wire [7:0] rec_delay;
wire [5:0] reset_ctrl;
reg tdc_strobe_reg = 0;
      //report signals 
wire [7:0] ram_ptr0;
wire stop_detected0;
wire buffer_full0;
wire [7:0] sample_size0;
wire [12:0] pulse_abs_coord0;
wire [7:0] ram_ptr1;
wire stop_detected1;
wire buffer_full1;
wire [7:0] sample_size1;
wire [12:0] pulse_abs_coord1;
wire [7:0] ram_ptr2;
wire stop_detected2;
wire buffer_full2;
wire [7:0] sample_size2;
wire [12:0] pulse_abs_coord2;
wire [7:0] ram_ptr3;
wire stop_detected3;
wire buffer_full3;
wire [7:0] sample_size3;
wire [12:0] pulse_abs_coord3;
wire [7:0] ram_ptr4;
wire stop_detected4;
wire buffer_full4;
wire [7:0] sample_size4;
wire [12:0] pulse_abs_coord4;
wire [7:0] ram_ptr5;
wire stop_detected5;
wire buffer_full5;
wire [7:0] sample_size5;
wire [12:0] pulse_abs_coord5;
     //av mm signals
wire [5:0] ram_cs;
wire [5:0] ram_write;
wire [7:0] ram0_addr;
wire [7:0] ram1_addr;
wire [7:0] ram2_addr;
wire [7:0] ram3_addr;
wire [7:0] ram4_addr;
wire [7:0] ram5_addr;

wire strobe_reset;

reg [4:0] tdc_strobe_cntr = 0;

assign start_bus[0]=cpu_start_command;
assign stop_bus[0]=comp_pulse&mem_master_selector[0];

assign start_bus[1]=comp_pulse&mem_master_selector[0];
assign stop_bus[1]=comp_pulse&mem_master_selector[1];

assign start_bus[2]=comp_pulse&mem_master_selector[1];
assign stop_bus[2]=comp_pulse&mem_master_selector[2];

assign start_bus[3]=comp_pulse&mem_master_selector[2];
assign stop_bus[3]=comp_pulse&mem_master_selector[3];

assign start_bus[4]=comp_pulse&mem_master_selector[3];
assign stop_bus[4]=comp_pulse&mem_master_selector[4];

assign start_bus[5]=comp_pulse&mem_master_selector[4];
assign stop_bus[5]=comp_pulse&mem_master_selector[5];


assign start_rec_cpu_domain=(~avs_reset)&avs_cs&(avs_addr==0)&avs_write&(avs_writedata[0]); //setting 0bit of control in 1 - start recording
assign recording_flag=control[0];
assign rec_delay=control[8:1];
assign reset_ctrl=control[14:9];

assign avm_clk=adc_clk;
assign avm_reset=0;    ///<=====================================
assign avm_writedata=adc_sample;
assign avm_cs=ram_cs;
assign avm0_addr=ram0_addr;
assign avm1_addr=ram1_addr;
assign avm2_addr=ram2_addr;
assign avm3_addr=ram3_addr;
assign avm4_addr=ram4_addr;
assign avm5_addr=ram5_addr;
assign avm_write=ram_write[5:0];

assign tdc_strobe=tdc_strobe_reg;

pulse_cross_domain comp_pulse_gen
(
  .pulse_in(direct_comp), //direct comparator output
  .clk_out(adc_clk),
  .pulse_out(comp_pulse) //direct comparator output in ADC CLK DOMAIN (pulse length - 1 clk period)
);

pulse_cross_domain start_pulse_gen
(
  .pulse_in(start_rec_cpu_domain), //direct comparator output 
  .clk_out(adc_clk),
  .pulse_out(cpu_start_command) //Start recording pulse in ADC CLK DOMAIN (pulse length - 1 clk period)
);

//Generation of strobe for TDC
assign strobe_reset=(tdc_strobe_cntr==5'b11111); //31 Tclk 
always@ (negedge adaptive_comp or posedge strobe_reset) //50m = 3.33*50*2 = 333.33ns --> 31..32 Tclk
         begin
		  if (strobe_reset) tdc_strobe_reg<=0;   //reset by counter
		  else tdc_strobe_reg<=1;                //Setting on posedge 
		 end 
always@ (posedge avs_clk)        //fixed freq
        begin
		 if (strobe_reset) tdc_strobe_cntr<=0;
		 else if (tdc_strobe_reg) tdc_strobe_cntr<=tdc_strobe_cntr+1;
		end 
		

//memory master selector
always@ (posedge adc_clk)
         begin
		   if (cpu_start_command) mem_master_selector<=6'b000001;
		   else if (comp_pulse) mem_master_selector<={mem_master_selector[4:0],mem_master_selector[5]}; //cycle shifter
		 end 
		 
//direct comparator pulse counter 
always@ (posedge adc_clk)
         begin
		  if (cpu_start_command) //reset
		    comp_pulse_cnt<=0;
		  else if (comp_pulse) 
		    comp_pulse_cnt<=comp_pulse_cnt+1;
		 end
		
//absolute coordinate counter 		
always@ (posedge adc_clk)
         begin
		  if (~recording_flag) //or cpu_start_command
		      absolute_counter<=0;
		  else
		      absolute_counter<=absolute_counter+1;
		 end 


//avalon mm slave controller		 
always@ (posedge avs_clk)
        begin
          if (avs_reset)
		     begin
			  control<=0;
			  //comp_pulse_cnt<=0;
			  //absolute_counter<=0;
			 end
		  else if (avs_write&avs_cs) //writing
		     begin
			 case (avs_addr)
			 0: begin control<=avs_writedata; end 
			 //1: begin comp_pulse_cnt<=avs_writedata; end 
			 //2: begin absolute_counter<=avs_writedata; end
			 default: begin end 
			 endcase 
			 end
		  else if (avs_read&avs_cs) //reading 
		     begin
			 case (avs_addr)
			 0: begin avs_readdata<=control; end 
			 1: begin avs_readdata<=comp_pulse_cnt; end 
			 2: begin avs_readdata<=absolute_counter; end
			 3: begin avs_readdata<={1'b0,pulse_abs_coord0[12:0],sample_size0[7:0],buffer_full0,stop_detected0,ram_ptr0[7:0]}; end //reports 
			 4: begin avs_readdata<={1'b0,pulse_abs_coord1[12:0],sample_size1[7:0],buffer_full1,stop_detected1,ram_ptr1[7:0]}; end 
			 5: begin avs_readdata<={1'b0,pulse_abs_coord2[12:0],sample_size2[7:0],buffer_full2,stop_detected2,ram_ptr2[7:0]}; end 
			 6: begin avs_readdata<={1'b0,pulse_abs_coord3[12:0],sample_size3[7:0],buffer_full3,stop_detected3,ram_ptr3[7:0]}; end 
			 7: begin avs_readdata<={1'b0,pulse_abs_coord4[12:0],sample_size4[7:0],buffer_full4,stop_detected4,ram_ptr4[7:0]}; end 
			 8: begin avs_readdata<={1'b0,pulse_abs_coord5[12:0],sample_size5[7:0],buffer_full5,stop_detected5,ram_ptr5[7:0]}; end 
			 default: begin end 
			 endcase 
			 end
        end 		

		 
//Start pulse 
memory_master u0
(
.reset(reset_ctrl[0]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[0]),//start pulse for recording
.stop(stop_bus[0]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[0]),
.av_addr(ram0_addr),
.av_write(ram_write[0]),
//Status signals
.ram_ptr(ram_ptr0), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected0), //stop pulse detected, flag
.buffer_full(buffer_full0), //process of recording was stoped
.sample_size(sample_size0), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord0) //absolute position of the pulse
);

//Stop pulse 1 
memory_master u1
(
.reset(reset_ctrl[1]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[1]),//start pulse for recording
.stop(stop_bus[1]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[1]),
.av_addr(ram1_addr),
.av_write(ram_write[1]),
//Status signals
.ram_ptr(ram_ptr1), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected1), //stop pulse detected, flag
.buffer_full(buffer_full1), //process of recording was stoped
.sample_size(sample_size1), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord1) //absolute position of the pulse
);

//Stop pulse 2 
memory_master u2
(
.reset(reset_ctrl[2]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[2]),//start pulse for recording
.stop(stop_bus[2]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[2]),
.av_addr(ram2_addr),
.av_write(ram_write[2]),
//Status signals
.ram_ptr(ram_ptr2), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected2), //stop pulse detected, flag
.buffer_full(buffer_full2), //process of recording was stoped
.sample_size(sample_size2), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord2) //absolute position of the pulse
);

//Stop pulse 3 
memory_master u3
(
.reset(reset_ctrl[3]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[3]),//start pulse for recording
.stop(stop_bus[3]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[3]),
.av_addr(ram3_addr),
.av_write(ram_write[3]),
//Status signals
.ram_ptr(ram_ptr3), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected3), //stop pulse detected, flag
.buffer_full(buffer_full3), //process of recording was stoped
.sample_size(sample_size3), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord3) //absolute position of the pulse
);

//Stop pulse 4 
memory_master u4
(
.reset(reset_ctrl[4]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[4]),//start pulse for recording
.stop(stop_bus[4]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[4]),
.av_addr(ram4_addr),
.av_write(ram_write[4]),
//Status signals
.ram_ptr(ram_ptr4), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected4), //stop pulse detected, flag
.buffer_full(buffer_full4), //process of recording was stoped
.sample_size(sample_size4), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord4) //absolute position of the pulse
);

//Stop pulse 5 
memory_master u5
(
.reset(reset_ctrl[5]), //reset 
.ref_clk(adc_clk), //reference clk
.start(start_bus[5]),//start pulse for recording
.stop(stop_bus[5]), //stop pulse for recording
.stop_delay(rec_delay), //delay from stop pulse to the end of recording
.coarse_counter(absolute_counter),
//avalon mm master
.av_cs(ram_cs[5]),
.av_addr(ram5_addr),
.av_write(ram_write[5]),
//Status signals
.ram_ptr(ram_ptr5), //current value of RAM pointer (memory master bus)
.stop_detected(stop_detected5), //stop pulse detected, flag
.buffer_full(buffer_full5), //process of recording was stoped
.sample_size(sample_size5), //count of samples recorded after start-pulse
.pulse_abs_coord(pulse_abs_coord5) //absolute position of the pulse
);

endmodule 