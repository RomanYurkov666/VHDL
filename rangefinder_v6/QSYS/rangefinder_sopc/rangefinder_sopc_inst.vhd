	component rangefinder_sopc is
		port (
			clk_clk                           : in    std_logic                    := 'X';             -- clk
			reset_reset_n                     : in    std_logic                    := 'X';             -- reset_n
			sys_timer_export                  : out   std_logic;                                       -- export
			pc_uart_rxd                       : in    std_logic                    := 'X';             -- rxd
			pc_uart_txd                       : out   std_logic;                                       -- txd
			leds_port_export                  : out   std_logic_vector(7 downto 0);                    -- export
			i2c_port_export                   : inout std_logic_vector(1 downto 0) := (others => 'X'); -- export
			laser_driver_ref_clk              : in    std_logic                    := 'X';             -- ref_clk
			laser_driver_driver_enable        : in    std_logic                    := 'X';             -- driver_enable
			laser_driver_laser                : out   std_logic;                                       -- laser
			laser_driver_comparator           : in    std_logic                    := 'X';             -- comparator
			spi_tdc_master_clk                : out   std_logic;                                       -- master_clk
			spi_tdc_master_csn                : out   std_logic;                                       -- master_csn
			spi_tdc_master_mosi               : out   std_logic;                                       -- master_mosi
			spi_tdc_master_miso               : in    std_logic                    := 'X';             -- master_miso
			pulse_generator_start_pulse       : out   std_logic;                                       -- start_pulse
			pulse_generator_stop_pulse        : out   std_logic;                                       -- stop_pulse
			spi_vga_master_clk                : out   std_logic;                                       -- master_clk
			spi_vga_master_csn                : out   std_logic;                                       -- master_csn
			spi_vga_master_mosi               : out   std_logic;                                       -- master_mosi
			spi_vga_master_miso               : in    std_logic                    := 'X';             -- master_miso
			rs485_de_export                   : out   std_logic;                                       -- export
			tdc_enable_export                 : out   std_logic;                                       -- export
			system_mode_export                : out   std_logic;                                       -- export
			amp_gain_export                   : out   std_logic;                                       -- export
			apd_overcurrent_export            : in    std_logic                    := 'X';             -- export
			spi_apd_master_clk                : out   std_logic;                                       -- master_clk
			spi_apd_master_csn                : out   std_logic;                                       -- master_csn
			spi_apd_master_mosi               : out   std_logic;                                       -- master_mosi
			spi_apd_master_miso               : in    std_logic                    := 'X';             -- master_miso
			iris_motor_dir                    : out   std_logic;                                       -- motor_dir
			iris_motor_step                   : out   std_logic;                                       -- motor_step
			iris_motor_en                     : out   std_logic;                                       -- motor_en
			atten_motor_dir                   : out   std_logic;                                       -- motor_dir
			atten_motor_step                  : out   std_logic;                                       -- motor_step
			atten_motor_en                    : out   std_logic;                                       -- motor_en
			laser_charge_ref_clk              : in    std_logic                    := 'X';             -- ref_clk
			laser_charge_driver_enable        : in    std_logic                    := 'X';             -- driver_enable
			laser_charge_laser                : out   std_logic;                                       -- laser
			laser_charge_comparator           : in    std_logic                    := 'X';             -- comparator
			tdc_start_pulse_gen_ref_clk       : in    std_logic                    := 'X';             -- ref_clk
			tdc_start_pulse_gen_driver_enable : in    std_logic                    := 'X';             -- driver_enable
			tdc_start_pulse_gen_laser         : out   std_logic;                                       -- laser
			tdc_start_pulse_gen_comparator    : in    std_logic                    := 'X';             -- comparator
			adc_clk_clk                       : in    std_logic                    := 'X';             -- clk
			adc_data_adc_data                 : in    std_logic_vector(7 downto 0) := (others => 'X'); -- adc_data
			adc_data_comparator               : in    std_logic                    := 'X'              -- comparator
		);
	end component rangefinder_sopc;

	u0 : component rangefinder_sopc
		port map (
			clk_clk                           => CONNECTED_TO_clk_clk,                           --                 clk.clk
			reset_reset_n                     => CONNECTED_TO_reset_reset_n,                     --               reset.reset_n
			sys_timer_export                  => CONNECTED_TO_sys_timer_export,                  --           sys_timer.export
			pc_uart_rxd                       => CONNECTED_TO_pc_uart_rxd,                       --             pc_uart.rxd
			pc_uart_txd                       => CONNECTED_TO_pc_uart_txd,                       --                    .txd
			leds_port_export                  => CONNECTED_TO_leds_port_export,                  --           leds_port.export
			i2c_port_export                   => CONNECTED_TO_i2c_port_export,                   --            i2c_port.export
			laser_driver_ref_clk              => CONNECTED_TO_laser_driver_ref_clk,              --        laser_driver.ref_clk
			laser_driver_driver_enable        => CONNECTED_TO_laser_driver_driver_enable,        --                    .driver_enable
			laser_driver_laser                => CONNECTED_TO_laser_driver_laser,                --                    .laser
			laser_driver_comparator           => CONNECTED_TO_laser_driver_comparator,           --                    .comparator
			spi_tdc_master_clk                => CONNECTED_TO_spi_tdc_master_clk,                --             spi_tdc.master_clk
			spi_tdc_master_csn                => CONNECTED_TO_spi_tdc_master_csn,                --                    .master_csn
			spi_tdc_master_mosi               => CONNECTED_TO_spi_tdc_master_mosi,               --                    .master_mosi
			spi_tdc_master_miso               => CONNECTED_TO_spi_tdc_master_miso,               --                    .master_miso
			pulse_generator_start_pulse       => CONNECTED_TO_pulse_generator_start_pulse,       --     pulse_generator.start_pulse
			pulse_generator_stop_pulse        => CONNECTED_TO_pulse_generator_stop_pulse,        --                    .stop_pulse
			spi_vga_master_clk                => CONNECTED_TO_spi_vga_master_clk,                --             spi_vga.master_clk
			spi_vga_master_csn                => CONNECTED_TO_spi_vga_master_csn,                --                    .master_csn
			spi_vga_master_mosi               => CONNECTED_TO_spi_vga_master_mosi,               --                    .master_mosi
			spi_vga_master_miso               => CONNECTED_TO_spi_vga_master_miso,               --                    .master_miso
			rs485_de_export                   => CONNECTED_TO_rs485_de_export,                   --            rs485_de.export
			tdc_enable_export                 => CONNECTED_TO_tdc_enable_export,                 --          tdc_enable.export
			system_mode_export                => CONNECTED_TO_system_mode_export,                --         system_mode.export
			amp_gain_export                   => CONNECTED_TO_amp_gain_export,                   --            amp_gain.export
			apd_overcurrent_export            => CONNECTED_TO_apd_overcurrent_export,            --     apd_overcurrent.export
			spi_apd_master_clk                => CONNECTED_TO_spi_apd_master_clk,                --             spi_apd.master_clk
			spi_apd_master_csn                => CONNECTED_TO_spi_apd_master_csn,                --                    .master_csn
			spi_apd_master_mosi               => CONNECTED_TO_spi_apd_master_mosi,               --                    .master_mosi
			spi_apd_master_miso               => CONNECTED_TO_spi_apd_master_miso,               --                    .master_miso
			iris_motor_dir                    => CONNECTED_TO_iris_motor_dir,                    --                iris.motor_dir
			iris_motor_step                   => CONNECTED_TO_iris_motor_step,                   --                    .motor_step
			iris_motor_en                     => CONNECTED_TO_iris_motor_en,                     --                    .motor_en
			atten_motor_dir                   => CONNECTED_TO_atten_motor_dir,                   --               atten.motor_dir
			atten_motor_step                  => CONNECTED_TO_atten_motor_step,                  --                    .motor_step
			atten_motor_en                    => CONNECTED_TO_atten_motor_en,                    --                    .motor_en
			laser_charge_ref_clk              => CONNECTED_TO_laser_charge_ref_clk,              --        laser_charge.ref_clk
			laser_charge_driver_enable        => CONNECTED_TO_laser_charge_driver_enable,        --                    .driver_enable
			laser_charge_laser                => CONNECTED_TO_laser_charge_laser,                --                    .laser
			laser_charge_comparator           => CONNECTED_TO_laser_charge_comparator,           --                    .comparator
			tdc_start_pulse_gen_ref_clk       => CONNECTED_TO_tdc_start_pulse_gen_ref_clk,       -- tdc_start_pulse_gen.ref_clk
			tdc_start_pulse_gen_driver_enable => CONNECTED_TO_tdc_start_pulse_gen_driver_enable, --                    .driver_enable
			tdc_start_pulse_gen_laser         => CONNECTED_TO_tdc_start_pulse_gen_laser,         --                    .laser
			tdc_start_pulse_gen_comparator    => CONNECTED_TO_tdc_start_pulse_gen_comparator,    --                    .comparator
			adc_clk_clk                       => CONNECTED_TO_adc_clk_clk,                       --             adc_clk.clk
			adc_data_adc_data                 => CONNECTED_TO_adc_data_adc_data,                 --            adc_data.adc_data
			adc_data_comparator               => CONNECTED_TO_adc_data_comparator                --                    .comparator
		);

