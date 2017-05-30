module cross_domain
(
input clk_a,
input pulse_a,
input clk_b,
output reg pulse_b
);

reg pulse_a1;
wire ff_a_rst;
reg ff_a = 0;
reg ff_b = 0;
wire pulse_a_posedge;

assign pulse_a_posedge = pulse_a & (~pulse_a1);

always@ (posedge clk_a)
		pulse_a1<=pulse_a;

always@ (posedge clk_a or posedge ff_a_rst)
        begin
	     if (ff_a_rst)
	     ff_a<=0;
	     else if (pulse_a_posedge)
	     ff_a<=1;
	    end 
	    
always@ (posedge clk_b)
        ff_b<=ff_a;
        
always@ (posedge clk_b)
	     pulse_b<=ff_b & (~pulse_b);

assign ff_a_rst=pulse_b;
	
endmodule 