
module rangefinder_sopc (
	clk_clk,
	reset_reset_n,
	sys_timer_export,
	pc_uart_rxd,
	pc_uart_txd,
	leds_port_export,
	i2c_port_export,
	laser_driver_ref_clk,
	laser_driver_driver_enable,
	laser_driver_laser,
	laser_driver_comparator,
	spi_tdc_master_clk,
	spi_tdc_master_csn,
	spi_tdc_master_mosi,
	spi_tdc_master_miso,
	pulse_generator_start_pulse,
	pulse_generator_stop_pulse,
	spi_vga_master_clk,
	spi_vga_master_csn,
	spi_vga_master_mosi,
	spi_vga_master_miso,
	rs485_de_export,
	tdc_enable_export,
	system_mode_export,
	amp_gain_export,
	apd_overcurrent_export,
	spi_apd_master_clk,
	spi_apd_master_csn,
	spi_apd_master_mosi,
	spi_apd_master_miso,
	iris_motor_dir,
	iris_motor_step,
	iris_motor_en,
	atten_motor_dir,
	atten_motor_step,
	atten_motor_en,
	laser_charge_ref_clk,
	laser_charge_driver_enable,
	laser_charge_laser,
	laser_charge_comparator,
	tdc_start_pulse_gen_ref_clk,
	tdc_start_pulse_gen_driver_enable,
	tdc_start_pulse_gen_laser,
	tdc_start_pulse_gen_comparator,
	adc_clk_clk,
	adc_data_adc_data,
	adc_data_comparator);	

	input		clk_clk;
	input		reset_reset_n;
	output		sys_timer_export;
	input		pc_uart_rxd;
	output		pc_uart_txd;
	output	[7:0]	leds_port_export;
	inout	[1:0]	i2c_port_export;
	input		laser_driver_ref_clk;
	input		laser_driver_driver_enable;
	output		laser_driver_laser;
	input		laser_driver_comparator;
	output		spi_tdc_master_clk;
	output		spi_tdc_master_csn;
	output		spi_tdc_master_mosi;
	input		spi_tdc_master_miso;
	output		pulse_generator_start_pulse;
	output		pulse_generator_stop_pulse;
	output		spi_vga_master_clk;
	output		spi_vga_master_csn;
	output		spi_vga_master_mosi;
	input		spi_vga_master_miso;
	output		rs485_de_export;
	output		tdc_enable_export;
	output		system_mode_export;
	output		amp_gain_export;
	input		apd_overcurrent_export;
	output		spi_apd_master_clk;
	output		spi_apd_master_csn;
	output		spi_apd_master_mosi;
	input		spi_apd_master_miso;
	output		iris_motor_dir;
	output		iris_motor_step;
	output		iris_motor_en;
	output		atten_motor_dir;
	output		atten_motor_step;
	output		atten_motor_en;
	input		laser_charge_ref_clk;
	input		laser_charge_driver_enable;
	output		laser_charge_laser;
	input		laser_charge_comparator;
	input		tdc_start_pulse_gen_ref_clk;
	input		tdc_start_pulse_gen_driver_enable;
	output		tdc_start_pulse_gen_laser;
	input		tdc_start_pulse_gen_comparator;
	input		adc_clk_clk;
	input	[7:0]	adc_data_adc_data;
	input		adc_data_comparator;
endmodule
