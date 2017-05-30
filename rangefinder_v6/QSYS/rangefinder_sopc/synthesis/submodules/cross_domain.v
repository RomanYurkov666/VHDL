module cross_domain
(
input clk_in,
input pulse_in,
input clk_out,
output reg pulse_out
);

reg pulse_in1;
wire ff_in_rst;
reg ff_in = 0;
reg ff_out = 0;
wire pulse_in_posedge;

assign pulse_in_posedge = pulse_in & (~pulse_in1);

always@ (posedge clk_in)
		pulse_in1<=pulse_in;

always@ (posedge clk_in or posedge ff_in_rst)
        begin
	     if (ff_in_rst)
	     ff_in<=0;
	     else if (pulse_in_posedge)
	     ff_in<=1;
	    end 
	    
always@ (posedge clk_out)
        ff_out<=ff_in;
        
always@ (posedge clk_out)
	     pulse_out<=ff_out & (~pulse_out);

assign ff_in_rst=pulse_out;
	
endmodule 