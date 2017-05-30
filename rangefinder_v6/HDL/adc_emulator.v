module adc_emulator
(
input clk,
output clko,
output [7:0] data
);

reg [7:0] cntr = 0;

assign clko=clk;
assign data=cntr;
  
always@ (posedge clk)
    cntr<=cntr+1;

endmodule 