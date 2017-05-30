module pulse_cross_domain
(
input pulse_in, //Входной импульс произвольной длительности
input clk_out, //выходной clk
output reg pulse_out //Выходной импульс длинной 1 такт выходного clk
);

wire reset;
reg driver = 0;

//pulse driver
always@ (posedge pulse_in or posedge reset)
        begin
		   if (reset) driver<=0;
			else driver<=1;
		  end 

assign reset=pulse_out;  
		  
always@ (posedge clk_out)
         begin
			 pulse_out<=driver;
			end 

endmodule 