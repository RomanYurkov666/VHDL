module laser_driver
(
input ref_clk, 
input driver_mod_en,
output laser_en,
input comparator, 
//avalon mm slave
input avmms_clk,
input avmms_reset,
input avmms_cs,
input [2:0] avmms_address,
input avmms_write,
input [31:0] avmms_writedata,
input avmms_read,
output reg [31:0] avmms_readdata
);

//Module - generator of laser enable strobe 
//3 modes:
//00: Start by CPU (with delay), stop after external comparator signal;
//01: Start by CPU (with delay), strobe length equivalent to "pulse length"
//10: Start by CPU (with delay), stop after external comparator signal (strobe length is limited by "pulse length");
//11: Start by CPU (with delay), stop after external comparator signal (with delay)

//intarface registers
reg [7:0] control = 0;  //control register bit0 - en/dis; bi2-bit1 - mode 
reg [7:0] status = 0;   //status register 
reg [31:0] pulse_length = 0; // length of pulse in ref_clk periods 
reg [31:0] pulse_delay = 0; // delay of pulse posedge in ref_clk periods  
reg [31:0] pulse_back_delay = 0; //delay of pulse negedge in ref_clk periods

//internal registers and signals
wire driver_enable; //enable for pulse
wire pulse_stop;
reg [32:0] counter = 0;
reg [31:0] delay_counter = 0;
reg laser_en_reg = 0;
reg laser_en_reg1 = 0;
wire pulse_stop_avmm;
wire [1:0] driver_mode;
wire en_back_cnt;
wire pulse_start;
wire pulse_stop_mod00;
wire pulse_stop_mod01;
wire pulse_stop_mod10;
wire pulse_stop_mod11;
reg pulse_stop_mux = 0;
reg back_cntr_en=0;
wire comp_ref;


assign pulse_start=(counter==pulse_delay); //start
assign pulse_stop_mod00=comp_ref; //stop by external comp signal 
assign pulse_stop_mod01=(counter==(pulse_delay+pulse_length)); //limited pulse length 
assign pulse_stop_mod10=pulse_stop_mod00|pulse_stop_mod01; //ext comp signal OR pulse length limit
assign pulse_stop_mod11=(delay_counter==pulse_back_delay); //delay after ext comp 

assign en_back_cnt=comp_ref&(driver_mode==3);
assign driver_enable=control[0]&driver_mod_en;
assign pulse_stop=laser_en_reg1&(~laser_en_reg); //negedge of laser pulse
assign laser_en=laser_en_reg;
assign driver_mode=control[2:1];

always@ (*) //multiplexer
        begin
        case (driver_mode)
		0: begin pulse_stop_mux<=pulse_stop_mod00; end 
		1: begin pulse_stop_mux<=pulse_stop_mod01; end 
		2: begin pulse_stop_mux<=pulse_stop_mod10; end 
		3: begin pulse_stop_mux<=pulse_stop_mod11; end 
		endcase 
        end 		

always@ (posedge ref_clk)
         begin
			  laser_en_reg1<=laser_en_reg;
			  if (~driver_enable) //if reset
			    begin
			     laser_en_reg<=0;
				 counter<=0;
				 back_cntr_en<=0;
			    end 
			  else 
			    begin
			     if (pulse_stop_mux)
				     laser_en_reg<=0;
				 else if (pulse_start)
				     laser_en_reg<=1;
			     counter<=counter+1;
				 if (en_back_cnt) back_cntr_en = 1;
				 if (back_cntr_en) delay_counter<=delay_counter+1;
				 end 
			end

pulse_cross_domain u0 //ref_clk domain ---> cpu clk domain
(
.pulse_in(pulse_stop_mux), //end
.clk_out(avmms_clk), //sdfsdf
.pulse_out(pulse_stop_avmm) //sdfk
);

pulse_cross_domain u1 //ext signal --> ref_clk domain
(
.pulse_in(comparator), //external comparator signal
.clk_out(ref_clk), //ref clk domain 
.pulse_out(comp_ref) //comparator pulse in clk_ref domain
);

//avalon mm slave
always@ (posedge avmms_clk)
         begin
			 if (avmms_reset)
			   begin
			   control<=0;
			   status<=0;
			   pulse_length<=0;
			   pulse_delay<=0;
			   end
			 else
			   begin
				 if (avmms_write&avmms_cs) //writing process 
				 begin
				  case (avmms_address)
				    0: begin control<=avmms_writedata; end
					1: begin status<=avmms_writedata; end
					2: begin pulse_length<=avmms_writedata; end
					3: begin pulse_delay<=avmms_writedata; end
					4: begin pulse_back_delay<=avmms_writedata; end
					default:  begin end
				  endcase 
				 end 
				 else if (pulse_stop_avmm) //clk cross domain!!!!!
				     control<=0; //reset 0 bit			
				 else if (avmms_read&avmms_cs) //reading process (delay - 1 Tclk)
				 begin
				  case (avmms_address)
				    0: begin avmms_readdata<=control; end
					1: begin avmms_readdata<=status; end
					2: begin avmms_readdata<=pulse_length; end
					3: begin avmms_readdata<=pulse_delay; end
					4: begin avmms_readdata<=pulse_back_delay; end
					default: begin avmms_readdata<=32'h89ABCDEF; end
				  endcase 
				 end

				end 
			end 

endmodule 