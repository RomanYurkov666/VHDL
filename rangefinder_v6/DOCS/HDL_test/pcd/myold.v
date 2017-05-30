module myold
(
input pulse_in, //������� ������� ������������ ������������
input clk_out, //�������� clk
output reg pulse_out //�������� ������� ������� 1 ���� ��������� clk
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