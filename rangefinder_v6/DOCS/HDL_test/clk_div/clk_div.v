module clk_div
(
input clk,
input reset,
input [7:0] divider,
output reg [7:0] counter,
output clk_en
);

reg [7:0] cntr = 0;
wire cntr_rst;
reg [7:0] divider1 = 0;

assign cntr_rst = (cntr == divider) || (divider^divider1);
assign clk_en = cntr_rst;

always@ (posedge clk)
begin
if (cntr_rst|reset)
cntr<=0;
else
cntr<=cntr+1;
divider1<=divider;
end

always@ (posedge clk)
begin
 if (reset)
 counter<=0;
 if (clk_en)
 counter<=counter+1;
end

endmodule 