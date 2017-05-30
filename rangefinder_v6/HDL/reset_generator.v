module reset_generator
(
input clk,
input pll_locked,
output global_reset
);

//clk=50MHz? Treset = (2^15)*20ns = 655 us

parameter CNTR_WIDTH = 16;

reg [CNTR_WIDTH-1:0] counter = 0;
reg hw_reset_reg = 0;
wire counter_en;
wire counter_reset;

assign counter_en=~counter[CNTR_WIDTH-1]; //hi bit
assign counter_reset=~pll_locked; //pll status
assign global_reset=hw_reset_reg;

always@ (posedge clk)
         begin
			 if (counter_reset) counter<=0;
			 else if (counter_en) counter<=counter+1;
			end 
			
always@ (posedge clk)
   hw_reset_reg<=~counter[CNTR_WIDTH-1];
	
endmodule 
