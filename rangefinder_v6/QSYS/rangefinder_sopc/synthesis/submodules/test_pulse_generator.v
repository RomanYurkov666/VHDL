module test_pulse_generator
(
//avalon mm
input avmm_reset,
input avmm_clk,
input avmm_cs,
input [2:0] avmm_addr,
input avmm_write,
input [31:0] avmm_writedata,
input avmm_read,
output reg [31:0] avmm_readdata,
//external
output start_pulse,
output stop_pulse
);

reg [31:0] control = 0;
reg [31:0] start_pulse_settings = 0;
reg [31:0] stop_pulse0_settings = 0;
reg [31:0] stop_pulse1_settings = 0;
reg [31:0] stop_pulse2_settings = 0;
reg [31:0] stop_pulse3_settings = 0;
reg [31:0] stop_pulse4_settings = 0;

wire [15:0] start_pulse_delay;
wire [14:0] start_pulse_len;
wire start_pulse_en;
wire [15:0] stop_pulse0_delay;
wire [14:0] stop_pulse0_len;
wire stop_pulse0_en;
wire [15:0] stop_pulse1_delay;
wire [14:0] stop_pulse1_len;
wire stop_pulse1_en;
wire [15:0] stop_pulse2_delay;
wire [14:0] stop_pulse2_len;
wire stop_pulse2_en;
wire [15:0] stop_pulse3_delay;
wire [14:0] stop_pulse3_len;
wire stop_pulse3_en;
wire [15:0] stop_pulse4_delay;
wire [14:0] stop_pulse4_len;
wire stop_pulse4_en;

wire start_generation;

wire start_pulse_generated;
wire stop_pulse0_generated;
wire stop_pulse1_generated;
wire stop_pulse2_generated;
wire stop_pulse3_generated;
wire stop_pulse4_generated;

assign start_pulse_delay = start_pulse_settings[15:0];
assign start_pulse_len = start_pulse_settings[30:16];
assign start_pulse_en = start_pulse_settings[31];

assign stop_pulse0_delay = stop_pulse0_settings[15:0];
assign stop_pulse0_len = stop_pulse0_settings[30:16];
assign stop_pulse0_en = stop_pulse0_settings[31];

assign stop_pulse1_delay = stop_pulse1_settings[15:0];
assign stop_pulse1_len = stop_pulse1_settings[30:16];
assign stop_pulse1_en = stop_pulse1_settings[31];

assign stop_pulse2_delay = stop_pulse2_settings[15:0];
assign stop_pulse2_len = stop_pulse2_settings[30:16];
assign stop_pulse2_en = stop_pulse2_settings[31];

assign stop_pulse3_delay = stop_pulse3_settings[15:0];
assign stop_pulse3_len = stop_pulse3_settings[30:16];
assign stop_pulse3_en = stop_pulse3_settings[31];

assign stop_pulse4_delay = stop_pulse4_settings[15:0];
assign stop_pulse4_len = stop_pulse4_settings[30:16];
assign stop_pulse4_en = stop_pulse4_settings[31];

assign start_generation = avmm_cs & avmm_write & (avmm_addr == 0) & avmm_writedata[0];

always@ (posedge avmm_clk)
		begin
			if (avmm_reset)
			 begin
			  control<=0;
			  start_pulse_settings<=0;
			  stop_pulse0_settings<=0;
			  stop_pulse1_settings<=0;
			  stop_pulse2_settings<=0;
			  stop_pulse3_settings<=0;
			  stop_pulse4_settings<=0;
			 end 
			else if (avmm_cs & avmm_write)
			 case (avmm_addr)
			 0: begin control<=avmm_writedata; end 
			 1: begin start_pulse_settings<=avmm_writedata; end 
			 2: begin stop_pulse0_settings<=avmm_writedata; end 
			 3: begin stop_pulse1_settings<=avmm_writedata; end 
			 4: begin stop_pulse2_settings<=avmm_writedata; end 
			 5: begin stop_pulse3_settings<=avmm_writedata; end 
			 6: begin stop_pulse4_settings<=avmm_writedata; end 
			 endcase
			else if (avmm_cs & avmm_read)
			 case (avmm_addr)
			 0: begin avmm_readdata<=control; end 
			 1: begin avmm_readdata<=start_pulse_settings; end 
			 2: begin avmm_readdata<=stop_pulse0_settings; end 
			 3: begin avmm_readdata<=stop_pulse1_settings; end 
			 4: begin avmm_readdata<=stop_pulse2_settings; end 
			 5: begin avmm_readdata<=stop_pulse3_settings; end 
			 6: begin avmm_readdata<=stop_pulse4_settings; end
			 endcase
		end 

single_pulse_gen start
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(start_pulse_delay),
  .len(start_pulse_len),
  .pulse_enable(start_pulse_en),
  .start(start_generation),
  .out_pulse(start_pulse_generated)
);

single_pulse_gen stop0
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(stop_pulse0_delay),
  .len(stop_pulse0_len),
  .pulse_enable(stop_pulse0_en),
  .start(start_generation),
  .out_pulse(stop_pulse0_generated)
);

single_pulse_gen stop1
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(stop_pulse1_delay),
  .len(stop_pulse1_len),
  .pulse_enable(stop_pulse1_en),
  .start(start_generation),
  .out_pulse(stop_pulse1_generated)
);

single_pulse_gen stop2
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(stop_pulse2_delay),
  .len(stop_pulse2_len),
  .pulse_enable(stop_pulse2_en),
  .start(start_generation),
  .out_pulse(stop_pulse2_generated)
);

single_pulse_gen stop3
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(stop_pulse3_delay),
  .len(stop_pulse3_len),
  .pulse_enable(stop_pulse3_en),
  .start(start_generation),
  .out_pulse(stop_pulse3_generated)
);

single_pulse_gen stop4
(
  .clk(avmm_clk),
  .reset(avmm_reset),
  .delay(stop_pulse4_delay),
  .len(stop_pulse4_len),
  .pulse_enable(stop_pulse4_en),
  .start(start_generation),
  .out_pulse(stop_pulse4_generated)
);

assign start_pulse = start_pulse_generated;
assign stop_pulse = stop_pulse0_generated | 
                    stop_pulse1_generated |
					stop_pulse2_generated |
					stop_pulse3_generated |
					stop_pulse4_generated;

endmodule 