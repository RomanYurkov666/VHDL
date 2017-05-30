module system_clock
(
input ref_clk,      //in clock - 50 MHz 
output clk_100MHz,  
output clk_200MHz,
output pll_locked,
output clk_2MHz
);

reg [3:0] self_reset = 4'b0001;
wire pll_areset;
wire pll_clk_100_MHz;
wire pll_clk_200_MHz;
wire pll_locked_status;

assign clk_100MHz=pll_clk_100_MHz;
assign clk_200MHz=pll_clk_200_MHz;
assign pll_locked=pll_locked_status;

assign pll_areset=self_reset[3];


always@ (posedge ref_clk or posedge pll_locked)
         begin
			 if (pll_locked) self_reset<=4'b0001;
			 else self_reset<={self_reset[2:0],1'b0};
			end
			
system_pll u0 
(
   .areset(pll_areset),
   .inclk0(ref_clk),
   .c0(pll_clk_100_MHz),
   .c1(pll_clk_200_MHz),
   .locked(pll_locked_status)
);

endmodule 
