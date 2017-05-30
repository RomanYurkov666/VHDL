module gauss_pulse
(
input clk,
input reset,
output [7:0] signal 
);

parameter AMP = 100;
parameter DELAY = 100;

localparam START = DELAY;
localparam END = START+11;

reg [31:0] cnt = 0;
reg strobe;
reg strobe1;
reg [3:0] loc_cnt = 0;
reg [7:0] signal_reg = 0;
wire [15:0] multiply;

assign signal=strobe1?multiply[15:8]:0;
assign multiply=signal_reg*AMP;

always@ (posedge clk)
         begin
		  strobe1<=strobe;
		  if (reset)
		  begin
		    cnt<=0;
			strobe<=0;
			loc_cnt<=0;
		  end
		  else
		  begin
		    cnt<=cnt+1;
		    if (cnt==END) strobe<=0;
		    else if (cnt==START) strobe<=1;
			if (strobe) 
			    begin
				loc_cnt<=loc_cnt+1;
				case (loc_cnt)
				//0:  begin signal_reg<=2; end 
				//1:  begin signal_reg<=14; end 
				//2:  begin signal_reg<=50; end 
				//3:  begin signal_reg<=124; end 
				//4:  begin signal_reg<=212; end 
				//5:  begin signal_reg<=255; end 
				//6:  begin signal_reg<=212; end 
				//7:  begin signal_reg<=124; end 
				//8:  begin signal_reg<=50; end 
				//9:  begin signal_reg<=14; end 
				//10: begin signal_reg<=2; end 
				1:  begin signal_reg<=14; end 
				2:  begin signal_reg<=124; end 
				3:  begin signal_reg<=255; end 
				4:  begin signal_reg<=124; end 
				5:  begin signal_reg<=14; end 
				default: begin signal_reg<=0; end 
				endcase 
				end 
		  end 
		 end 

endmodule 