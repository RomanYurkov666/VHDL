module single_pulse_gen
(
  input clk,
  input reset,
  input [15:0] delay,
  input [14:0] len,
  input pulse_enable,
  input start,
  output reg out_pulse
);

reg [16:0] abs_counter = 0;
reg abs_counter_en = 0;
wire abs_counter_stop;
wire [16:0] cnt_limit;
wire pulse_set;
wire pulse_reset;

assign cnt_limit = delay + len;

assign abs_counter_stop = (abs_counter >= cnt_limit);

assign pulse_set = (abs_counter == delay) & pulse_enable;
assign pulse_reset = (abs_counter == cnt_limit);


always@ (posedge clk)
		begin
		 if (reset|abs_counter_stop)
			begin
			abs_counter<=0;
			abs_counter_en<=0;
			end
		 else if (start&pulse_enable)
			abs_counter_en<=1;
		 if (abs_counter_en)
			abs_counter<=abs_counter+1;
		end 
		
always@ (posedge clk)
		begin
		 if (reset|pulse_reset)
			out_pulse<=0;
		 else if (pulse_set)
			out_pulse<=1;
		end 

endmodule 