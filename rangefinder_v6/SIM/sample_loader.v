module sample_loader
(
//photosignal
input adc_clk,
input [7:0] adc_signal,
//control signals 
input ext_start,
input comp,
input delayed_comp,
output tdc_dis_strobe,
output memory_full,
output stop_detected,
//avalon mm slave (to Nios)
input avmms_clk,
input avmms_reset,
input avmms_cs,
input [3:0] avmms_address,
input avmms_write,
input [31:0] avmms_writedata,
input avmms_read,
output reg [31:0] avmms_readdata,
output irq,
//avalon mm master (to RAM)
output avmm_clk,
output avmm_reset,
output avmm_cs,
output [8:0] avmm_address, //512 bytes
output avmm_write,
output [7:0] avmm_writedata,
output avmm_read,
input [7:0] avmm_readdata
);

//control[1] = enable external start
//control[0] = recording flag 

parameter MEMORY_SIZE = 512; //bytes

//interface registers
reg [15:0] control = 0;
reg [15:0] status = 0;
reg [15:0] mem_ptr = 0;


//internal registers and signals
wire record_mode;
wire start_record;
wire record_stop;
wire record_start;
reg record_in_process = 0;
reg record_in_process1 = 0;
wire interrupt_pulse;
wire int_req;
wire record_start_ext;
wire int_start;

assign record_mode=control[1]; //start from external or internal signal
assign start_record=control[0];
assign interrupt_pulse = (~record_in_process)&record_in_process1;
assign record_start=(record_start_ext&record_mode)|(record_start_int&(~record_mode));
assign int_start=(~avmms_reset)&avmms_cs&(avmms_address==0)&avmms_write&avmms_writedata[2];

assign avmm_clk=adc_clk;
assign avmm_cs=record_in_process;
assign avmm_reset=0;
assign avmm_address=mem_ptr;
assign avmm_write=record_in_process;
assign avmm_writedata=adc_signal;
assign irq=status[0];

always@ (posedge adc_clk) //adc clock domain
         begin
           if (record_in_process)
              begin
               if (mem_ptr==(MEMORY_SIZE-1)) mem_ptr<=0;
               else mem_ptr<=mem_ptr+1;
              end
           if (record_stop) record_in_process<=0;
           else if (record_start) record_in_process<=1;
           record_in_process1<=record_in_process;
         end 

pulse_cross_domain u0
(
  .pulse_in(interrupt_pulse), //from adc clk domain
  .clk_out(avmms_clk), 
  .pulse_out(int_req) //to cpu clk domain
);
pulse_cross_domain u1
(
  .pulse_in(stop), //from comparator
  .clk_out(adc_clk), 
  .pulse_out(record_stop) //to adc clk domain
);
pulse_cross_domain u2
(
  .pulse_in(start), //from external start 
  .clk_out(adc_clk), 
  .pulse_out(record_start_ext) //to adc clk domain
);
pulse_cross_domain u3
(
  .pulse_in(int_start), //from cpu
  .clk_out(adc_clk), 
  .pulse_out(record_start_int) //to adc clk domain
);

//avalon mm slave
always@ (posedge avmms_clk)
         begin
			 if (avmms_reset)
			   begin
			   control<=0;
			   status<=0;
			   //mem_ptr<=0;
			   end
			 else
			   begin
				 if (avmms_read&avmms_cs) //reading process (delay - 1 Tclk)
				 begin
				  case (avmms_address)
				    0: begin avmms_readdata<=control; end
				    1: begin avmms_readdata<=status; end
					2: begin avmms_readdata<=mem_ptr; end
					default: begin avmms_readdata<=16'hCCCC; end
				  endcase 
				 end
				 else if (avmms_write&avmms_cs) //writing process 
				 begin
				  case (avmms_address)
				    0: begin control<=avmms_writedata; end
					//1: begin status<=avmms_writedata; end
					//2: begin mem_ptr<=avmms_writedata; end
					default:  begin end
				  endcase 
				 end 
				end 
			  if (int_req) status<=1; //interrupt flag
			end 

endmodule 