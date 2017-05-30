module timestamp_cntr
(
	input reset,
	input clk,
	input start,
	input stop,
	output [12:0] fine_cnt,
	output [7:0] coarse_cnt
);


reg [12:0] fine_counter = 0;
reg [7:0] coarse_counter = 0;

reg fine_counter_en = 0;

wire fine_counter_rst;
wire rst_fine_counter_en, set_fine_counter_en;
wire coarse_counter_rst, coarse_counter_en;

assign fine_counter_rst = reset;
assign rst_fine_counter_en = stop;
assign set_fine_counter_en = start;
assign coarse_counter_rst = reset;
assign coarse_counter_en = (fine_counter == 0)&fine_counter_en;

always@ (posedge clk)
	if (rst_fine_counter_en)
		fine_counter_en = 1'b0;
	else if (set_fine_counter_en)
		fine_counter_en = 1'b1;
		
always@ (posedge clk)
	if (fine_counter_rst)
		fine_counter <= 0;
	else if (fine_counter_en)
		fine_counter <= fine_counter + 1'b1;
		
always@ (posedge clk)
	if (coarse_counter_rst)
		coarse_counter <= 0;
	else if (coarse_counter_en)
		coarse_counter <= coarse_counter + 1'b1;
		
assign fine_cnt = fine_counter;
assign coarse_cnt = coarse_counter;

endmodule 