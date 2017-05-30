`timescale 1ns/100ps
module tb_loader_v2();

reg clk_500MHz;
reg clk_100MHz;
reg generators_reset;
reg [3:0] noise;
reg av_cpu_reset;
reg av_cpu_cs;
reg [3:0] av_cpu_addr;
reg av_cpu_write;
reg [31:0] av_cpu_writedata;
reg av_cpu_read;
wire [31:0] av_cpu_readdata;

reg direct_comparator;
reg adaptive_comparator;

wire [7:0] start_pulse; //100 ns delay
wire [7:0] stop_pulse1; //50m = + ~330ns
wire [7:0] stop_pulse2; //500m = + ~3330ns
wire [7:0] stop_pulse3; //1km = + ~6660ns
wire [7:0] stop_pulse4; //5km = + ~33300ns
wire [7:0] stop_pulse5; //10km = + ~66600ns
wire [7:0] photosignal;
reg [7:0] photosignal1;
reg [7:0] photosignal2;
reg [7:0] photosignal3;

wire avm_clk;
wire avm_reset;
wire [7:0] avm_writedata;
wire [5:0] avm_cs;
wire [5:0] avm_write;
wire [7:0] avm_address0;
wire [7:0] avm_address1;
wire [7:0] avm_address2;
wire [7:0] avm_address3;
wire [7:0] avm_address4;
wire [7:0] avm_address5;




initial
   begin
   clk_500MHz=1;
   clk_100MHz=1;
   generators_reset=1;
   direct_comparator=0;
   adaptive_comparator=0;
   av_cpu_reset=1;
   av_cpu_cs=0;
   av_cpu_addr=0;
   av_cpu_write=0;
   av_cpu_writedata=0;
   av_cpu_read=0;
   photosignal1=0;
   photosignal2=0;
   photosignal3=0;
   #100
   generators_reset=0;
   av_cpu_reset=0;
   #100
   av_cpu_cs=1;
   av_cpu_write=1;
   av_cpu_addr=0;
   av_cpu_writedata=32'h0000001F;
   #10
   av_cpu_cs=0;
   av_cpu_write=0;
   av_cpu_addr=0;
   av_cpu_writedata=0;
   end 
   
always #1 clk_500MHz<=~clk_500MHz;
always #5 clk_100MHz<=~clk_100MHz;
always #2 noise=$random;

always #2 direct_comparator<=(photosignal>40);
always #2 adaptive_comparator<=(photosignal3>photosignal)&(photosignal3>20); //20 - treshold

always #2 begin 
          photosignal1<=photosignal;
		  photosignal2<=photosignal1;
		  photosignal3<=photosignal2;
		  end 

//500 MHz
gauss_pulse #(.AMP(220),.DELAY(50)) st_gen    (.clk(clk_500MHz), .reset(generators_reset), .signal(start_pulse) ); //33*5=165 clk 
gauss_pulse #(.AMP(180),.DELAY(165)) stop1_gen (.clk(clk_500MHz), .reset(generators_reset), .signal(stop_pulse1) );
gauss_pulse #(.AMP(150),.DELAY(1650)) stop2_gen (.clk(clk_500MHz), .reset(generators_reset), .signal(stop_pulse2) );
gauss_pulse #(.AMP(120),.DELAY(3330)) stop3_gen (.clk(clk_500MHz), .reset(generators_reset), .signal(stop_pulse3) );
gauss_pulse #(.AMP(80),.DELAY(16500)) stop4_gen (.clk(clk_500MHz), .reset(generators_reset), .signal(stop_pulse4) );
gauss_pulse #(.AMP(60),.DELAY(33300)) stop5_gen (.clk(clk_500MHz), .reset(generators_reset), .signal(stop_pulse5) );

assign photosignal=start_pulse+stop_pulse1+stop_pulse2+stop_pulse3+stop_pulse4+stop_pulse5+noise;

sample_loader u0
(
    .reset(0),     //global reset
    .adc_clk(clk_100MHz),   //adc clock out 
    .adc_sample(photosignal), //adc bus
    .direct_comp(direct_comparator), //async comparator out
    .adaptive_comp(adaptive_comparator), //async adaptive comparator  
    .avs_reset(av_cpu_reset),
    .avs_clk(clk_100MHz),
    .avs_cs(av_cpu_cs),
    .avs_addr(av_cpu_addr),
    .avs_write(av_cpu_write),
    .avs_writedata(av_cpu_writedata),
    .avs_read(av_cpu_read),
    .avs_readdata(av_cpu_readdata),
    .avm_clk(avm_clk),
    .avm_reset(avm_reset),
    .avm_writedata(avm_writedata),
    .avm_cs(avm_cs), //CSs for 6 RAM
    .avm_write(avm_write), //write strobes for 6 RAM
    .avm0_addr(avm_address0),
    .avm1_addr(avm_address1),
    .avm2_addr(avm_address2),
    .avm3_addr(avm_address3),
    .avm4_addr(avm_address4),
    .avm5_addr(avm_address5) //addresses for 6 RAM
);

endmodule 