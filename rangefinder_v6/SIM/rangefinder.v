module rangefinder
(
input SYSTEM_CLK,          //external reference 10 MHz generator
//interface with AD9480 (Fast ADC)
input AD9480_CLKO_p,
input AD9480_CLKO_n,
input AD9480_D0_p,
input AD9480_D0_n,
input AD9480_D1_p,
input AD9480_D1_n,
input AD9480_D2_p,
input AD9480_D2_n,
input AD9480_D3_p,
input AD9480_D3_n,
input AD9480_D4_p,
input AD9480_D4_n,
input AD9480_D5_p,
input AD9480_D5_n,
input AD9480_D6_p,
input AD9480_D6_n,
input AD9480_D7_p,
input AD9480_D7_n,
output AD9480_S1,  //Data format select and duty-cycle stabilizer selection
output AD9480_PDWN, //power-down selection
//interface with SSD1305 (OLED controller)
output [2:0] SSD1305_BS, //MCU bus interface selection pins
input SSD1305_FR, //pin outputs RAM write synchronization signal
output SSD1305_CLS, //When it is pulled HIGH (i.e. connect to VDDIO), internal clock is enabled
output SSD1305_RES, //This pin is reset signal input
output SSD1305_CS, //This pin is the chip select input. (active LOW)
output SSD1305_D_C, //This is Data/Command control pin. When it is pulled HIGH (i.e. connect to VDDIO), the data at D[7:0] is treated as data.
output SSD1305_E, // ????
output SSD1305_R_W, //This is read / write control input pin connecting to the MCU
output [7:0] SSD1305_DATA, //These are 8-bit bi-directional data bus
//interface with lmh6881 (programmable differential amplifier)
output LMH6881_OCM, //Output Common Mode, gain of 2
output LMH6881_SPI_MODE, //Serial mode control
output LMH6881_SPI_MOSI,
input LMH6881_SPI_MISO,
output LMH6881_SPI_CLK,
output LMH6881_SPI_CS,
output LMH6881_SD, //shutdown
//interface with lps331ap (pressure sensor)
output LPS331AP_SPI_CS, //(1: I2C mode; 0: SPI enabled)
output LPS331AP_SPI_CLK,
output LPS331AP_SPI_MOSI,
input  LPS331AP_SPI_MISO,
input  LPS331AP_INT1, //Interrupt 1 (or data ready)
input  LPS331AP_INT2, //Interrupt 2 (or data ready)
//interface with m41t00s (real time clock)
inout  M41T00S_SDA, 
output M41T00S_SCL,
//intarface with sht20 (humidity and temperature sensor)
inout  SHT20_SDA, 
output SHT20_SCL,
//interface with SST25VF080B (serial flash)
output SST25_SPI_CS,
output SST25_SPI_CLK,
output SST25_SPI_MOSI,
input SST25_SPI_MISO,
output SST25_WP, //The Write Protect (WP#) pin is used to enable/disable BPL bit in the status register
output SST25_HOLD, //To temporarily stop serial communication with SPI flash memory without resetting the device
// Interface with TDC7200 (time to digital converter)
output TDC_SPI_CLK,
output TDC_SPI_CS,
output TDC_SPI_MOSI,
input TDC_SPI_MISO,
output TDC_ENABLE,
input TDC_TRIGG,
input TDC_INTB,
//Interface with laser
output LASER_EN, //start pulse for laser
//Interface with DAC7612 (low speed reference)
output DAC7612_SPI_CS,
output DAC7612_SPI_CLK,
output DAC7612_SPI_MOSI,
output DAC7612_LOAD,
//Control of irises (2 pwm)
output PWM0_H,
output PWM0_L,
output PWM1_H,
output PWM1_L,
//Buttons
input [7:0] BUTTONS,
//Comparators
input [4:0] COMPARATORS,
output TX_RS232,
input  RX_RS232
);

wire fast_adc_clk;
wire [7:0] fast_adc_data;
wire clk_100_MHz;
wire clk_40_MHz;
wire clk_160_MHz;
wire pll_locked;
wire global_reset;

wire [8:0] loader_address;
wire [7:0] loader_data;
wire loader_cs;
wire loader_clk;
wire loader_reset;
wire loader_write;

system_clk u0
(
   .ref_clk(SYSTEM_CLK),
   .clk_100MHz(clk_100_MHz),
   .clk_40MHz(clk_40_MHz),
   .clk_160MHz(clk_160_MHz),
   .pll_locked(pll_locked)
);

reset_generator u1
(
   .system_clk(SYSTEM_CLK),
   .pll_locked(pll_locked),
   .global_reset(global_reset)
);

lrf_sopc sopc (
        .clk_clk                                (clk_100_MHz),                                //                            clk.clk
        .reset_reset_n                          (~global_reset),                          //                          reset.reset_n
        .spi_press_MISO                         (LPS331AP_SPI_MISO),                         //                      spi_press.MISO
        .spi_press_MOSI                         (LPS331AP_SPI_MOSI),                         //                               .MOSI
        .spi_press_SCLK                         (LPS331AP_SPI_CLK),                         //                               .SCLK
        .spi_press_SS_n                         (LPS331AP_SPI_CS),                         //                               .SS_n
        .spi_amp_MISO                           (LMH6881_SPI_MISO),                           //                        spi_amp.MISO
        .spi_amp_MOSI                           (LMH6881_SPI_MOSI),                           //                               .MOSI
        .spi_amp_SCLK                           (LMH6881_SPI_CLK),                           //                               .SCLK
        .spi_amp_SS_n                           (LMH6881_SPI_CS),                           //                               .SS_n
        //.uart_3_rxd                             (<connected-to-uart_3_rxd>),                             //                         uart_3.rxd
        //.uart_3_txd                             (<connected-to-uart_3_txd>),                             //                               .txd
        //.uart_2_rxd                             (<connected-to-uart_2_rxd>),                             //                         uart_2.rxd
        //.uart_2_txd                             (<connected-to-uart_2_txd>),                             //                               .txd
        //.uart_1_rxd                             (<connected-to-uart_1_rxd>),                             //                         uart_1.rxd
        //.uart_1_txd                             (<connected-to-uart_1_txd>),                             //                               .txd
        .uart_0_rxd                             (RX_RS232),                             //                         uart_0.rxd
        .uart_0_txd                             (TX_RS232),                             //                               .txd
        .spi_flash_MISO                         (SST25_SPI_MISO),                         //                      spi_flash.MISO
        .spi_flash_MOSI                         (SST25_SPI_MOSI),                         //                               .MOSI
        .spi_flash_SCLK                         (SST25_SPI_CLK),                         //                               .SCLK
        .spi_flash_SS_n                         (SST25_SPI_CS),                         //                               .SS_n
        .spi_tdc_MISO                           (TDC_SPI_MISO),                           //                        spi_tdc.MISO
        .spi_tdc_MOSI                           (TDC_SPI_MOSI),                           //                               .MOSI
        .spi_tdc_SCLK                           (TDC_SPI_CLK),                           //                               .SCLK
        .spi_tdc_SS_n                           (TDC_SPI_CS),                           //                               .SS_n
        .spi_dac_MISO                           (DAC7612_SPI_MISO),                           //                        spi_dac.MISO
        .spi_dac_MOSI                           (DAC7612_SPI_MOSI),                           //                               .MOSI
        .spi_dac_SCLK                           (DAC7612_SPI_CLK),                           //                               .SCLK
        .spi_dac_SS_n                           (DAC7612_SPI_CS),                           //                               .SS_n
        .i2c_rtc_in_port                        (M41T00S_SDA),                        //                        i2c_rtc.in_port
        .i2c_rtc_out_port                       (M41T00S_SCL),                       //                               .out_port
        .i2c_temp_in_port                       (SHT20_SDA),                       //                       i2c_temp.in_port
        .i2c_temp_out_port                      (SHT20_SCL),                      //                               .out_port
        //.display_port_in_port                 (),                   //                   display_port.in_port
        //.display_port_out_port                (),                  //                               .out_port
        //.control_signals_in_port                (),                //                control_signals.in_port
        //.control_signals_out_port               (),               //                               .out_port
        .buttons_export                         (BUTTONS),                         //                        buttons.export
        .laser_enable                           (1),                           //                          laser.enable
        .laser_laser_driver                     (LASER_EN),                     //                               .laser_driver
        .laser_clk_clk                          (clk_100_MHz),                          //                      laser_clk.clk
        .pwm_driver_iris_reciever_pwm_l         (PWM0_L),         //       pwm_driver_iris_reciever.pwm_l
        .pwm_driver_iris_reciever_pwm_h         (PWM0_H),         //                               .pwm_h
        .pwm_driver_iris_reciever_enable        (1),        //                               .enable
        .pwm_driver_iris_laser_pwm_l            (PWM1_l),            //          pwm_driver_iris_laser.pwm_l
        .pwm_driver_iris_laser_pwm_h            (PWM1_H),            //                               .pwm_h
        .pwm_driver_iris_laser_enable           (1),           //                               .enable
        .pwm_driver_iris_reciever_clock_clk     (clk_100_MHz),     // pwm_driver_iris_reciever_clock.clk
        .pwm_driver_iris_laser_clock_clk        (clk_100_MHz),        //    pwm_driver_iris_laser_clock.clk
        .sample_loader_stop                     (COMPARATORS[0]),                     //                  sample_loader.stop
        //.sample_loader_start                    (),                    //                               .start
        .sample_loader_adc_signal               (fast_adc_data),               //                               .adc_signal
        .sample_loader_adc_clk_clk              (fast_adc_clk),              //          sample_loader_adc_clk.clk
        .sample_loader_avalon_master_address    (loader_address),    //    sample_loader_avalon_master.address
        .sample_loader_avalon_master_chipselect (loader_cs), //                               .chipselect
        .sample_loader_avalon_master_write      (loader_write),      //                               .write
        .sample_loader_avalon_master_writedata  (loader_data),  //                               .writedata
        //.sample_loader_avalon_master_read       (<connected-to-sample_loader_avalon_master_read>),       //                               .read
        //.sample_loader_avalon_master_readdata   (<connected-to-sample_loader_avalon_master_readdata>),   //                               .readdata
        .sample_loader_reset_source_reset       (loader_reset),       //     sample_loader_reset_source.reset
        .sample_loader_clock_source_clk         (loader_clk),         //     sample_loader_clock_source.clk
        .sample_ram_s2_address                  (loader_address),                  //                  sample_ram_s2.address
        .sample_ram_s2_chipselect               (loader_cs),               //                               .chipselect
        .sample_ram_s2_clken                    (1),                    //                               .clken
        .sample_ram_s2_write                    (loader_write),                    //                               .write
        //.sample_ram_s2_readdata                 (<connected-to-sample_ram_s2_readdata>),                 //                               .readdata
        .sample_ram_s2_writedata                (loader_data),                //                               .writedata
        .sample_ram_clk2_clk                    (loader_clk),                    //                sample_ram_clk2.clk
        .sample_ram_reset2_reset                (loader_reset),                //              sample_ram_reset2.reset
        //.sample_ram_reset2_reset_req            (<connected-to-sample_ram_reset2_reset_req>)             //                               .reset_req
    );


//lvds reciever buffers
buf_rx buf_rx_u0
  (.datain(AD9480_CLKO_p),
	.datain_b(AD9480_CLKO_n),
	.dataout(fast_adc_clk));
buf_rx buf_rx_u1
  (.datain(AD9480_D0_p),
	.datain_b(AD9480_D0_n),
	.dataout(fast_adc_data[0]));
buf_rx buf_rx_u2
  (.datain(AD9480_D1_p),
	.datain_b(AD9480_D1_n),
	.dataout(fast_adc_data[1]));
buf_rx buf_rx_u3
  (.datain(AD9480_D2_p),
	.datain_b(AD9480_D2_n),
	.dataout(fast_adc_data[2]));
buf_rx buf_rx_u4
  (.datain(AD9480_D3_p),
	.datain_b(AD9480_D3_n),
	.dataout(fast_adc_data[3]));
buf_rx buf_rx_u5
  (.datain(AD9480_D4_p),
	.datain_b(AD9480_D4_n),
	.dataout(fast_adc_data[4]));
buf_rx buf_rx_u6
  (.datain(AD9480_D5_p),
	.datain_b(AD9480_D5_n),
	.dataout(fast_adc_data[5]));
buf_rx buf_rx_u7
  (.datain(AD9480_D6_p),
	.datain_b(AD9480_D6_n),
	.dataout(fast_adc_data[6]));
buf_rx buf_rx_u8
  (.datain(AD9480_D7_p),
	.datain_b(AD9480_D7_n),
	.dataout(fast_adc_data[7]));

endmodule 