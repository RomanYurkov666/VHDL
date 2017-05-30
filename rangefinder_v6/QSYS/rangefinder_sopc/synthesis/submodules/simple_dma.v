module simple_dma
(
	input clk, //adc clock
	input reset, //reset 
	input start_transfer, //signal from cpu
	output busy, //transfer in process
	output ready, //ready transfer 
	input [7:0] fifo_q, 
	input [7:0] fifo_usdw,
	output fifo_rdreq,
	output [7:0] ram_addr, 
	output [7:0] ram_d,
	output ram_wren 
);

localparam st_idle = 1'd0;
localparam st_transfer = 1'd1;

reg state = st_idle;
reg next_state = st_transfer;
reg [7:0] ram_ptr_cntr = 8'h0;
reg busy1 = 0;

wire transfer_complete,transfer_in_process;

assign transfer_complete = (fifo_usdw == 8'h0) & (state == st_transfer);
assign start_data_transfer = start_transfer & (state == st_idle);

assign transfer_in_process = (state == st_transfer);

assign ram_wren = transfer_in_process;
assign ram_addr = ram_ptr_cntr;
assign ram_d = fifo_q;
assign fifo_rdreq = transfer_in_process;
assign busy = transfer_in_process;
assign ready = (~busy)&busy1;


always@ (posedge clk)
	if (transfer_complete|reset)
		state <= st_idle;
	else if (start_data_transfer)
		state <= st_transfer;

always@ (posedge clk)
	if (!transfer_in_process)
		ram_ptr_cntr <=0;
	else
		ram_ptr_cntr <= ram_ptr_cntr + 1'b1;
		
always @(posedge clk)
	busy1 <= busy;
		
endmodule 
