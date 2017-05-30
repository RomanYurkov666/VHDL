module trigger_pulse_gen
(
	input clk,
	input [7:0] sample,
	input [7:0] threshold,
	input direction,
	output reg trigger
);

parameter DELAY = 10;

localparam st_less_or_eq = 1'b0;
localparam st_more_or_eq = 1'b1;

reg state = st_less_or_eq;
reg next_state = st_less_or_eq;
reg [7:0] sample_ff = 0;
reg excitation_pulse = 0;
reg [DELAY-1:0] delay_shift_reg = 0;
reg out_strobe = 0;
reg out_strobe1 = 0;

wire more_than_threshold_flag, less_than_threshold_flag;
wire up_transition, down_transition;

assign more_than_threshold_flag = (sample_ff[7:0] > threshold[7:0]);
assign less_than_threshold_flag = (sample_ff[7:0] < threshold[7:0]);
assign up_transition = (next_state == st_more_or_eq) & (state == st_less_or_eq);
assign down_transition = (next_state == st_less_or_eq) & (state == st_more_or_eq);

//buffer
always@ (posedge clk)
	sample_ff[7:0] <= sample[7:0];

//fsm
always@ (posedge clk)
	state <= next_state;
	
always@ (state, more_than_threshold_flag, less_than_threshold_flag)
	begin
		next_state = st_less_or_eq;
		case (state)
		st_less_or_eq: begin
			if (more_than_threshold_flag)
				next_state=st_more_or_eq;
			else
				next_state=st_less_or_eq;
		end 
		st_more_or_eq: begin 
			if (less_than_threshold_flag)
				next_state=st_less_or_eq;
			else
				next_state=st_more_or_eq;
		end 
		endcase
	end 

always@ (posedge clk)
	excitation_pulse <= (direction ? up_transition : down_transition)&(~trigger);
	
always@ (posedge clk)
  begin
    delay_shift_reg[DELAY-1:0]={delay_shift_reg[DELAY-2:0],excitation_pulse};
    out_strobe <= (|delay_shift_reg[DELAY-1:0]);
    out_strobe1 <= out_strobe;
    trigger <= out_strobe&(~out_strobe1);
  end

endmodule 