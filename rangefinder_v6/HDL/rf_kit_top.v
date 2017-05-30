module rf_kit_top
(
//on-board
input SYSTEM_CLK, //50MHz, located on R8
//input [1:0] BUTTONS, //E1,J15
//input [3:0] DIP, //M15,B9,T8,M1
//output [7:0] LEDS, //L3,B1,F3,D1,A11,B13,A13,A15
output ON_BOARD_LED_3,
output I2C_SCL, //F2, on-board i2c
inout I2C_SDA, //F1
//output ADC_SPI_CS, //A10, on-board spi (slow adc)
//output ADC_SPI_CLK, //B14
//output ADC_SPI_MOSI, //B10
//input  ADC_SPI_MISO, //A9
//output [12:0] SDRAM_ADDR,
//output SDRAM_CLK,
//output SDRAM_CKE,
//output [1:0] SDRAM_DQM,
//output SDRAM_WE_N,
//output SDRAM_CAS_N,
//output SDRAM_RAS_N,
//output SDRAM_CS_N,
//output [1:0] SDRAM_BA,
//inout [15:0] SDRAM_DQ, 
//external interfaces
//fast adc bus
output AD9480_CLK, //lvds out
input AD9480_CLKO, //lvds in
input AD9480_D0,   //lvds in
input AD9480_D1,   //lvds in
input AD9480_D2,   //lvds in
input AD9480_D3,   //lvds in
input AD9480_D4,   //lvds in
input AD9480_D5,   //lvds in
input AD9480_D6,   //lvds in
input AD9480_D7,   //lvds in
//time-to-digital converter
output SPI_CS_TDC,
output SPI_CLK_TDC,
output SPI_MOSI_TDC,
input  SPI_MISO_TDC,
output TDC_STROBE,
output TDC_START,
//output TDC_STOP, //Test P14
//amplifier
output SPI_CS_AD8369,
output SPI_CLK_AD8369,
output SPI_MOSI_AD8369,
output AMP_GAIN,
//APD 
output SPI_CS_MAX1932,
output SPI_CLK_MAX1932,
output SPI_MOSI_MAX1932,
input APD_OVERCUR,
//comparator
input AD_COMPARATOR,
//laser control
output LASER_ENABLE,
output LASER_CHARGE,
//Stepper, attenuator
output ATTEN_EN,
output ATTEN_DIR,
output ATTEN_STEP,
//Stepper, iris
output IRIS_EN,
output IRIS_DIR,
output IRIS_STEP,
//Internal RS485 bus
input RS485_RX,
output RS485_TX,
output RS485_DE,
//test
output COMP_RESET //N14
);

reg [7:0] adc_buf_reg = 0;

wire cpu_clk_100_MHz;
wire adc_clk_200_MHz;
wire pll_locked;
wire global_reset;
wire [15:0] cpu_port;

wire [7:0] adc_sample;
wire adc_clko;
wire direct_comparator;

wire system_mode;
wire test_gen_start;

wire laser;
wire cpu_tdc_enable;

wire laser_charge_driver;
wire laser_enable_driver;
wire tdc_start_gen_pulse;

wire stepper_controller_en_iris,stepper_controller_en_attenuator;

wire test_gen_out;

assign direct_comparator=system_mode?AD_COMPARATOR:test_gen_out;
assign TDC_START=system_mode?tdc_start_gen_pulse:test_gen_start;
assign TDC_STROBE=cpu_tdc_enable;

assign adc_sample={AD9480_D7,AD9480_D6,AD9480_D5,AD9480_D4,AD9480_D3,AD9480_D2,AD9480_D1,AD9480_D0};
assign adc_clko=AD9480_CLKO;
assign AD9480_CLK = adc_clk_200_MHz;

assign LASER_CHARGE = laser_charge_driver;
assign LASER_ENABLE = ~laser_enable_driver;
assign IRIS_EN=~stepper_controller_en_iris;
assign ATTEN_EN=~stepper_controller_en_attenuator;

always@ (posedge AD9480_CLKO)
	adc_buf_reg<=adc_sample;


//system clocks
system_clock sys_clk
(
   .ref_clk(SYSTEM_CLK),      //50 MHz
   .clk_100MHz(cpu_clk_100_MHz),  
   .clk_200MHz(adc_clk_200_MHz),
   .pll_locked(pll_locked)
);

//reset generator
reset_generator #(.CNTR_WIDTH(20)) rst_gen
(
   .clk(SYSTEM_CLK),
   .pll_locked(pll_locked),
   .global_reset(global_reset)
);

wire [7:0] leds;
assign ON_BOARD_LED_3=leds[3];

adc_emulator adc_test
(
   .clk(adc_clk_200_MHz)//,
   //.clko(adc_clko),
   //.data(adc_sample)
);

//system on a chip 
  rangefinder_sopc sopc (
        .clk_clk                    (cpu_clk_100_MHz),                    //             clk.clk
        .reset_reset_n              (~global_reset),              //           reset.reset_n
        .pc_uart_rxd                (RS485_RX|RS485_DE),                //         pc_uart.rxd
        .pc_uart_txd                (RS485_TX),                //                .txd
		  .rs485_de_export                 (RS485_DE),
        .leds_port_export           (leds),           //       leds_port.export
        .i2c_port_export            ({I2C_SDA,I2C_SCL}),            //        i2c_port.export
        .system_mode_export              (system_mode),              //          system_mode.export
        .laser_driver_ref_clk       (adc_clk_200_MHz),       //    laser_driver.ref_clk
        .laser_driver_driver_enable (~global_reset), //                .driver_enable
        .laser_driver_laser         (laser_enable_driver),         //                .laser
        .laser_driver_comparator    (direct_comparator),     //                .comparator 
		  .spi_tdc_master_clk       (SPI_CLK_TDC),       //       spi_controller.master_clk
        .spi_tdc_master_csn       (SPI_CS_TDC),       //                     .master_csn
        .spi_tdc_master_mosi      (SPI_MOSI_TDC),      //                     .master_mosi
        .spi_tdc_master_miso      (SPI_MISO_TDC),      //                     .master_miso
        .spi_vga_master_clk              (SPI_CLK_AD8369),              //              spi_vga.master_clk
        .spi_vga_master_csn              (SPI_CS_AD8369),              //                     .master_csn
        .spi_vga_master_mosi             (SPI_MOSI_AD8369),             //                     .master_mosi
        .spi_apd_master_clk              (SPI_CLK_MAX1932),              //              spi_apd.master_clk
        .spi_apd_master_csn              (SPI_CS_MAX1932),              //                     .master_csn
        .spi_apd_master_mosi             (SPI_MOSI_MAX1932),             //                     .master_mosi
        .pulse_generator_start_pulse     (test_gen_start),     //      pulse_generator.start_pulse
        .pulse_generator_stop_pulse      (test_gen_out),       //                     .stop_pulse
        .atten_motor_dir                 (ATTEN_DIR),                 //                atten.motor_dir
        .atten_motor_step                (ATTEN_STEP),                //                     .motor_step
        .atten_motor_en                  (stepper_controller_en_attenuator),                  //                     .motor_en
        .iris_motor_dir                  (IRIS_DIR),                  //                 iris.motor_dir
        .iris_motor_step                 (IRIS_STEP),                 //                     .motor_step
        .iris_motor_en                   (stepper_controller_en_iris),                   //                     .motor_en
		  .tdc_enable_export               (cpu_tdc_enable),  	
        .amp_gain_export                 (AMP_GAIN),                 //             amp_gain.export
        .apd_overcurrent_export          (APD_OVERCUR),          //      apd_overcurrent.export
		  .laser_charge_ref_clk            (adc_clk_200_MHz),            //         laser_charge.ref_clk
        .laser_charge_driver_enable      (~global_reset),      //                     .driver_enable
        .laser_charge_laser              (laser_charge_driver),              //                     .laser
        .laser_charge_comparator         (direct_comparator),          //      
        .tdc_start_pulse_gen_ref_clk       (adc_clk_200_MHz),       //  tdc_start_pulse_gen.ref_clk
        .tdc_start_pulse_gen_driver_enable (~global_reset), //                     .driver_enable
        .tdc_start_pulse_gen_laser         (tdc_start_gen_pulse),         //                     .laser
        .tdc_start_pulse_gen_comparator    (direct_comparator),     //   		  .comparator
		  .adc_clk_clk                       (adc_clko),                       //             adc_clk.clk
        .adc_data_adc_data                 (adc_buf_reg),//adc_sample),                 //            adc_data.adc_data
        .adc_data_comparator               (direct_comparator)                //                    .comparator
	 );
	 
comp_reset_generator comp_rst_gen
(
	.reset(global_reset),
	.ref_clk(adc_clk_200_MHz),
	.comp_out(AD_COMPARATOR),
	.rst_driver(COMP_RESET)
);
	 

endmodule 