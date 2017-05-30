module stepper_controller
(
//avalon
input avs_clk,
input avs_reset,
input avs_cs,
input [1:0] avs_address,
input avs_write,
input [31:0] avs_writedata,
input avs_read,
output reg [31:0] avs_readdata,
//stepper
output en,
output step,
output dir
);

localparam ST_IDLE = 2'b00;
localparam ST_UNLIMITED_MOV = 2'b01;
localparam ST_LIMITED_MOV = 2'b10;

localparam MODE_UNLIMITED = 1'b0;
localparam MODE_LIMITED = 1'b1;

reg [31:0] motor_speed_divider = 32'd100000; //100 MHz -> 100 Hz
reg [31:0] motor_position = 32'd00; 
reg [31:0] motor_control = 32'd00;
reg [31:0] motor_distance = 32'd00;
reg [31:0] end_position = 32'd00; 

reg [1:0] state = ST_IDLE;
reg [1:0] next_state = ST_IDLE;

wire step_posedge;
reg [31:0] step_driver_cntr = 32'd0; 
reg step_driver = 0; 
reg step_driver1 = 0;
wire step_driver_cntr_rst,step_driver_cntr_en;

wire start_movement_cmd,stop_movement_cmd;
wire mode;
wire positioning_completed;
wire reset_position;

assign step_driver_cntr_rst = (step_driver_cntr[31:0] >= motor_speed_divider[31:0]);
assign step_driver_cntr_en = en; //always
assign step_posedge = ~step_driver1 & step_driver;
assign reset_position = avs_reset | (avs_cs&avs_write&(avs_address==2'b1)&(avs_writedata[0] == 1'b1));
assign start_movement_cmd = ~avs_reset & avs_cs & avs_write & (avs_address == 0) & (avs_writedata[0] == 1'b1); //motor_control[0]
assign stop_movement_cmd = ~avs_reset & avs_cs & avs_write & (avs_address == 0) & (avs_writedata[0] == 1'b0); //motor_control[0]
assign mode = motor_control[1];
assign positioning_completed = (motor_position == end_position) && (state == ST_LIMITED_MOV);



//fsm********************************************************************************
always@ (posedge avs_clk)
	if (avs_reset)
		state<=ST_IDLE;
	else
		state<=next_state;

always@ (state,start_movement_cmd,mode,stop_movement_cmd,positioning_completed)
	begin
		next_state = ST_IDLE;
		case (state)
		ST_IDLE: 	
			begin
			if (start_movement_cmd)
				next_state=mode?ST_LIMITED_MOV:ST_UNLIMITED_MOV;
			else
			next_state = ST_IDLE;
			end
		ST_UNLIMITED_MOV: 
			begin 
			if (stop_movement_cmd)
			next_state = ST_IDLE;
			else
			next_state = ST_UNLIMITED_MOV;
			end
		ST_LIMITED_MOV: 
			begin 
			if (stop_movement_cmd|positioning_completed)
			next_state = ST_IDLE;
			else
			next_state = ST_LIMITED_MOV;
			end
		default: 
			begin 
			next_state = ST_IDLE;
			end
		endcase 
	end 
//******************************************************************************************

//driver logic
always@ (posedge avs_clk)
	begin
	 if (step_driver_cntr_rst)
		begin
		step_driver_cntr<=0;
		step_driver<=~step_driver;
		end 
	 else if (step_driver_cntr_en)
		step_driver_cntr<=step_driver_cntr+1;
	 step_driver1<=step_driver;
	end 
	
always@ (posedge avs_clk)
	begin
		if (reset_position)
			motor_position<=0;
		else if (step_posedge)
			motor_position<=(dir)?(motor_position+1'b1):(motor_position-1'b1);
	end 
	
always@ (posedge avs_clk)
		if ((next_state == ST_LIMITED_MOV) & (state == ST_IDLE))
			end_position<=(dir)?(motor_position + motor_distance) : (motor_position - motor_distance);
	
assign en = (state!=ST_IDLE);
assign step = step_driver & en;
assign dir = motor_control[2];
	
//*******************************************************************************************

//interface**********************************************************************************
always@ (posedge avs_clk)
	if (avs_reset)
		begin
			motor_speed_divider <= 32'd100000; 
			motor_control <= 32'd00;
			motor_distance <= 32'd00;
		end
	else
		begin
			if (avs_cs&avs_write)
			case (avs_address)
			0: begin motor_control<=avs_writedata; end
			2: begin motor_speed_divider<=avs_writedata; end
			3: begin motor_distance<=avs_writedata; end 
			default: begin end
			endcase
			else if (avs_cs&avs_read)
			case (avs_address)
			0: begin avs_readdata<=motor_control; end 
			1: begin avs_readdata<=motor_position; end 
			2: begin avs_readdata<=motor_speed_divider; end 
			3: begin avs_readdata<=motor_distance; end 
			default: begin avs_readdata<=32'habcd; end
			endcase
		end 
//*******************************************************************************************
endmodule 