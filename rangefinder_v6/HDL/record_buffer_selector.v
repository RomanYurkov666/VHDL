module record_buffer_selector
(
	input reset,
	input clk,
	input start_rec,
	input pulse,
	output [5:0] stop_pulse
);

reg [5:0] stop_enable = 0;

always@ (posedge clk)
	if (reset)
		stop_enable[5:0] <= 6'h0;
	else if (start_rec)
		stop_enable[5:0] <= 6'h1;
	else if (pulse)
		stop_enable[5:0] <= {stop_enable[4:0],1'b0};
		
		
assign stop_pulse[5:0] = stop_enable[5:0]&({6{pulse}});

endmodule 