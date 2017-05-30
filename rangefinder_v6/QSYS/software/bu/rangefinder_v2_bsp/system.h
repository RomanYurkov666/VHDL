/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu' in SOPC Builder design 'rangefinder_sopc'
 * SOPC Builder design path: ../../rangefinder_sopc.sopcinfo
 *
 * Generated: Sat Oct 29 17:36:43 MSD 2016
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00008820
#define ALT_CPU_CPU_FREQ 133333333u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x10
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x00000020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 133333333
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x10
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_RESET_ADDR 0x00000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00008820
#define NIOS2_CPU_FREQ 133333333u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x10
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x00000020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x10
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_RESET_ADDR 0x00000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SPI
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_QSYS
#define __LASER_DRIVER
#define __PULSE_GENERATOR
#define __SAMPLE_LOADER
#define __SPI_CONTROLLER


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/pc_uart"
#define ALT_STDERR_BASE 0x9700
#define ALT_STDERR_DEV pc_uart
#define ALT_STDERR_IS_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_uart"
#define ALT_STDIN "/dev/pc_uart"
#define ALT_STDIN_BASE 0x9700
#define ALT_STDIN_DEV pc_uart
#define ALT_STDIN_IS_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_uart"
#define ALT_STDOUT "/dev/pc_uart"
#define ALT_STDOUT_BASE 0x9700
#define ALT_STDOUT_DEV pc_uart
#define ALT_STDOUT_IS_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_uart"
#define ALT_SYSTEM_NAME "rangefinder_sopc"


/*
 * buttons_port configuration
 *
 */

#define ALT_MODULE_CLASS_buttons_port altera_avalon_pio
#define BUTTONS_PORT_BASE 0x9760
#define BUTTONS_PORT_BIT_CLEARING_EDGE_REGISTER 0
#define BUTTONS_PORT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BUTTONS_PORT_CAPTURE 0
#define BUTTONS_PORT_DATA_WIDTH 6
#define BUTTONS_PORT_DO_TEST_BENCH_WIRING 0
#define BUTTONS_PORT_DRIVEN_SIM_VALUE 0
#define BUTTONS_PORT_EDGE_TYPE "NONE"
#define BUTTONS_PORT_FREQ 133333333
#define BUTTONS_PORT_HAS_IN 1
#define BUTTONS_PORT_HAS_OUT 0
#define BUTTONS_PORT_HAS_TRI 0
#define BUTTONS_PORT_IRQ -1
#define BUTTONS_PORT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BUTTONS_PORT_IRQ_TYPE "NONE"
#define BUTTONS_PORT_NAME "/dev/buttons_port"
#define BUTTONS_PORT_RESET_VALUE 0
#define BUTTONS_PORT_SPAN 16
#define BUTTONS_PORT_TYPE "altera_avalon_pio"


/*
 * gpio configuration
 *
 */

#define ALT_MODULE_CLASS_gpio altera_avalon_pio
#define GPIO_BASE 0x9680
#define GPIO_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO_BIT_MODIFYING_OUTPUT_REGISTER 1
#define GPIO_CAPTURE 0
#define GPIO_DATA_WIDTH 8
#define GPIO_DO_TEST_BENCH_WIRING 0
#define GPIO_DRIVEN_SIM_VALUE 0
#define GPIO_EDGE_TYPE "NONE"
#define GPIO_FREQ 133333333
#define GPIO_HAS_IN 0
#define GPIO_HAS_OUT 0
#define GPIO_HAS_TRI 1
#define GPIO_IRQ -1
#define GPIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO_IRQ_TYPE "NONE"
#define GPIO_NAME "/dev/gpio"
#define GPIO_RESET_VALUE 0
#define GPIO_SPAN 32
#define GPIO_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_TIMER
#define ALT_TIMESTAMP_CLK none


/*
 * i2c_port configuration
 *
 */

#define ALT_MODULE_CLASS_i2c_port altera_avalon_pio
#define I2C_PORT_BASE 0x96c0
#define I2C_PORT_BIT_CLEARING_EDGE_REGISTER 0
#define I2C_PORT_BIT_MODIFYING_OUTPUT_REGISTER 1
#define I2C_PORT_CAPTURE 0
#define I2C_PORT_DATA_WIDTH 2
#define I2C_PORT_DO_TEST_BENCH_WIRING 0
#define I2C_PORT_DRIVEN_SIM_VALUE 0
#define I2C_PORT_EDGE_TYPE "NONE"
#define I2C_PORT_FREQ 133333333
#define I2C_PORT_HAS_IN 0
#define I2C_PORT_HAS_OUT 0
#define I2C_PORT_HAS_TRI 1
#define I2C_PORT_IRQ -1
#define I2C_PORT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define I2C_PORT_IRQ_TYPE "NONE"
#define I2C_PORT_NAME "/dev/i2c_port"
#define I2C_PORT_RESET_VALUE 0
#define I2C_PORT_SPAN 32
#define I2C_PORT_TYPE "altera_avalon_pio"


/*
 * laser_driver configuration
 *
 */

#define ALT_MODULE_CLASS_laser_driver laser_driver
#define LASER_DRIVER_BASE 0x9660
#define LASER_DRIVER_IRQ -1
#define LASER_DRIVER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LASER_DRIVER_NAME "/dev/laser_driver"
#define LASER_DRIVER_SPAN 32
#define LASER_DRIVER_TYPE "laser_driver"


/*
 * leds_port configuration
 *
 */

#define ALT_MODULE_CLASS_leds_port altera_avalon_pio
#define LEDS_PORT_BASE 0x96e0
#define LEDS_PORT_BIT_CLEARING_EDGE_REGISTER 0
#define LEDS_PORT_BIT_MODIFYING_OUTPUT_REGISTER 1
#define LEDS_PORT_CAPTURE 0
#define LEDS_PORT_DATA_WIDTH 8
#define LEDS_PORT_DO_TEST_BENCH_WIRING 0
#define LEDS_PORT_DRIVEN_SIM_VALUE 0
#define LEDS_PORT_EDGE_TYPE "NONE"
#define LEDS_PORT_FREQ 133333333
#define LEDS_PORT_HAS_IN 0
#define LEDS_PORT_HAS_OUT 1
#define LEDS_PORT_HAS_TRI 0
#define LEDS_PORT_IRQ -1
#define LEDS_PORT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LEDS_PORT_IRQ_TYPE "NONE"
#define LEDS_PORT_NAME "/dev/leds_port"
#define LEDS_PORT_RESET_VALUE 0
#define LEDS_PORT_SPAN 32
#define LEDS_PORT_TYPE "altera_avalon_pio"


/*
 * pc_uart configuration
 *
 */

#define ALT_MODULE_CLASS_pc_uart altera_avalon_uart
#define PC_UART_BASE 0x9700
#define PC_UART_BAUD 115200
#define PC_UART_DATA_BITS 8
#define PC_UART_FIXED_BAUD 1
#define PC_UART_FREQ 133333333
#define PC_UART_IRQ 1
#define PC_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PC_UART_NAME "/dev/pc_uart"
#define PC_UART_PARITY 'N'
#define PC_UART_SIM_CHAR_STREAM ""
#define PC_UART_SIM_TRUE_BAUD 0
#define PC_UART_SPAN 32
#define PC_UART_STOP_BITS 1
#define PC_UART_SYNC_REG_DEPTH 2
#define PC_UART_TYPE "altera_avalon_uart"
#define PC_UART_USE_CTS_RTS 0
#define PC_UART_USE_EOP_REGISTER 0


/*
 * pulse_generator configuration
 *
 */

#define ALT_MODULE_CLASS_pulse_generator pulse_generator
#define PULSE_GENERATOR_BASE 0x9640
#define PULSE_GENERATOR_IRQ -1
#define PULSE_GENERATOR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PULSE_GENERATOR_NAME "/dev/pulse_generator"
#define PULSE_GENERATOR_SPAN 32
#define PULSE_GENERATOR_TYPE "pulse_generator"


/*
 * ram_cpu configuration
 *
 */

#define ALT_MODULE_CLASS_ram_cpu altera_avalon_onchip_memory2
#define RAM_CPU_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_CPU_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_CPU_BASE 0x0
#define RAM_CPU_CONTENTS_INFO ""
#define RAM_CPU_DUAL_PORT 1
#define RAM_CPU_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_CPU_INIT_CONTENTS_FILE "rangefinder_sopc_ram_cpu"
#define RAM_CPU_INIT_MEM_CONTENT 1
#define RAM_CPU_INSTANCE_ID "NONE"
#define RAM_CPU_IRQ -1
#define RAM_CPU_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_CPU_NAME "/dev/ram_cpu"
#define RAM_CPU_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_CPU_RAM_BLOCK_TYPE "AUTO"
#define RAM_CPU_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_CPU_SINGLE_CLOCK_OP 1
#define RAM_CPU_SIZE_MULTIPLE 1
#define RAM_CPU_SIZE_VALUE 32768
#define RAM_CPU_SPAN 32768
#define RAM_CPU_TYPE "altera_avalon_onchip_memory2"
#define RAM_CPU_WRITABLE 1


/*
 * ram_sample_0 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_0 altera_avalon_onchip_memory2
#define RAM_SAMPLE_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_0_BASE 0x9500
#define RAM_SAMPLE_0_CONTENTS_INFO ""
#define RAM_SAMPLE_0_DUAL_PORT 1
#define RAM_SAMPLE_0_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_0_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_0"
#define RAM_SAMPLE_0_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_0_INSTANCE_ID "NONE"
#define RAM_SAMPLE_0_IRQ -1
#define RAM_SAMPLE_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_0_NAME "/dev/ram_sample_0"
#define RAM_SAMPLE_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_0_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_0_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_0_SIZE_MULTIPLE 1
#define RAM_SAMPLE_0_SIZE_VALUE 256
#define RAM_SAMPLE_0_SPAN 256
#define RAM_SAMPLE_0_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_0_WRITABLE 1


/*
 * ram_sample_1 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_1 altera_avalon_onchip_memory2
#define RAM_SAMPLE_1_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_1_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_1_BASE 0x9400
#define RAM_SAMPLE_1_CONTENTS_INFO ""
#define RAM_SAMPLE_1_DUAL_PORT 1
#define RAM_SAMPLE_1_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_1_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_1"
#define RAM_SAMPLE_1_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_1_INSTANCE_ID "NONE"
#define RAM_SAMPLE_1_IRQ -1
#define RAM_SAMPLE_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_1_NAME "/dev/ram_sample_1"
#define RAM_SAMPLE_1_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_1_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_1_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_1_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_1_SIZE_MULTIPLE 1
#define RAM_SAMPLE_1_SIZE_VALUE 256
#define RAM_SAMPLE_1_SPAN 256
#define RAM_SAMPLE_1_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_1_WRITABLE 1


/*
 * ram_sample_2 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_2 altera_avalon_onchip_memory2
#define RAM_SAMPLE_2_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_2_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_2_BASE 0x9300
#define RAM_SAMPLE_2_CONTENTS_INFO ""
#define RAM_SAMPLE_2_DUAL_PORT 1
#define RAM_SAMPLE_2_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_2_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_2"
#define RAM_SAMPLE_2_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_2_INSTANCE_ID "NONE"
#define RAM_SAMPLE_2_IRQ -1
#define RAM_SAMPLE_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_2_NAME "/dev/ram_sample_2"
#define RAM_SAMPLE_2_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_2_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_2_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_2_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_2_SIZE_MULTIPLE 1
#define RAM_SAMPLE_2_SIZE_VALUE 256
#define RAM_SAMPLE_2_SPAN 256
#define RAM_SAMPLE_2_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_2_WRITABLE 1


/*
 * ram_sample_3 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_3 altera_avalon_onchip_memory2
#define RAM_SAMPLE_3_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_3_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_3_BASE 0x9200
#define RAM_SAMPLE_3_CONTENTS_INFO ""
#define RAM_SAMPLE_3_DUAL_PORT 1
#define RAM_SAMPLE_3_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_3_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_3"
#define RAM_SAMPLE_3_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_3_INSTANCE_ID "NONE"
#define RAM_SAMPLE_3_IRQ -1
#define RAM_SAMPLE_3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_3_NAME "/dev/ram_sample_3"
#define RAM_SAMPLE_3_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_3_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_3_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_3_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_3_SIZE_MULTIPLE 1
#define RAM_SAMPLE_3_SIZE_VALUE 256
#define RAM_SAMPLE_3_SPAN 256
#define RAM_SAMPLE_3_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_3_WRITABLE 1


/*
 * ram_sample_4 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_4 altera_avalon_onchip_memory2
#define RAM_SAMPLE_4_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_4_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_4_BASE 0x9100
#define RAM_SAMPLE_4_CONTENTS_INFO ""
#define RAM_SAMPLE_4_DUAL_PORT 1
#define RAM_SAMPLE_4_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_4_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_4"
#define RAM_SAMPLE_4_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_4_INSTANCE_ID "NONE"
#define RAM_SAMPLE_4_IRQ -1
#define RAM_SAMPLE_4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_4_NAME "/dev/ram_sample_4"
#define RAM_SAMPLE_4_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_4_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_4_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_4_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_4_SIZE_MULTIPLE 1
#define RAM_SAMPLE_4_SIZE_VALUE 256
#define RAM_SAMPLE_4_SPAN 256
#define RAM_SAMPLE_4_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_4_WRITABLE 1


/*
 * ram_sample_5 configuration
 *
 */

#define ALT_MODULE_CLASS_ram_sample_5 altera_avalon_onchip_memory2
#define RAM_SAMPLE_5_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_SAMPLE_5_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_SAMPLE_5_BASE 0x9000
#define RAM_SAMPLE_5_CONTENTS_INFO ""
#define RAM_SAMPLE_5_DUAL_PORT 1
#define RAM_SAMPLE_5_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_5_INIT_CONTENTS_FILE "rangefinder_sopc_ram_sample_5"
#define RAM_SAMPLE_5_INIT_MEM_CONTENT 1
#define RAM_SAMPLE_5_INSTANCE_ID "NONE"
#define RAM_SAMPLE_5_IRQ -1
#define RAM_SAMPLE_5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_SAMPLE_5_NAME "/dev/ram_sample_5"
#define RAM_SAMPLE_5_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_SAMPLE_5_RAM_BLOCK_TYPE "AUTO"
#define RAM_SAMPLE_5_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SAMPLE_5_SINGLE_CLOCK_OP 0
#define RAM_SAMPLE_5_SIZE_MULTIPLE 1
#define RAM_SAMPLE_5_SIZE_VALUE 256
#define RAM_SAMPLE_5_SPAN 256
#define RAM_SAMPLE_5_TYPE "altera_avalon_onchip_memory2"
#define RAM_SAMPLE_5_WRITABLE 1


/*
 * sample_loader configuration
 *
 */

#define ALT_MODULE_CLASS_sample_loader sample_loader
#define SAMPLE_LOADER_BASE 0x9600
#define SAMPLE_LOADER_IRQ -1
#define SAMPLE_LOADER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SAMPLE_LOADER_NAME "/dev/sample_loader"
#define SAMPLE_LOADER_SPAN 64
#define SAMPLE_LOADER_TYPE "sample_loader"


/*
 * spi configuration
 *
 */

#define ALT_MODULE_CLASS_spi altera_avalon_spi
#define SPI_BASE 0x96a0
#define SPI_CLOCKMULT 1
#define SPI_CLOCKPHASE 0
#define SPI_CLOCKPOLARITY 0
#define SPI_CLOCKUNITS "Hz"
#define SPI_DATABITS 8
#define SPI_DATAWIDTH 16
#define SPI_DELAYMULT "1.0E-9"
#define SPI_DELAYUNITS "ns"
#define SPI_EXTRADELAY 0
#define SPI_INSERT_SYNC 0
#define SPI_IRQ 2
#define SPI_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SPI_ISMASTER 1
#define SPI_LSBFIRST 0
#define SPI_NAME "/dev/spi"
#define SPI_NUMSLAVES 8
#define SPI_PREFIX "spi_"
#define SPI_SPAN 32
#define SPI_SYNC_REG_DEPTH 2
#define SPI_TARGETCLOCK 16000000u
#define SPI_TARGETSSDELAY "0.0"
#define SPI_TYPE "altera_avalon_spi"


/*
 * spi_controller configuration
 *
 */

#define ALT_MODULE_CLASS_spi_controller spi_controller
#define SPI_CONTROLLER_BASE 0x9750
#define SPI_CONTROLLER_IRQ -1
#define SPI_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SPI_CONTROLLER_NAME "/dev/spi_controller"
#define SPI_CONTROLLER_SPAN 16
#define SPI_CONTROLLER_TYPE "spi_controller"


/*
 * spi_controller_vga configuration
 *
 */

#define ALT_MODULE_CLASS_spi_controller_vga spi_controller
#define SPI_CONTROLLER_VGA_BASE 0x9740
#define SPI_CONTROLLER_VGA_IRQ -1
#define SPI_CONTROLLER_VGA_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SPI_CONTROLLER_VGA_NAME "/dev/spi_controller_vga"
#define SPI_CONTROLLER_VGA_SPAN 16
#define SPI_CONTROLLER_VGA_TYPE "spi_controller"


/*
 * sys_id configuration
 *
 */

#define ALT_MODULE_CLASS_sys_id altera_avalon_sysid_qsys
#define SYS_ID_BASE 0x9770
#define SYS_ID_ID 320043385
#define SYS_ID_IRQ -1
#define SYS_ID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYS_ID_NAME "/dev/sys_id"
#define SYS_ID_SPAN 8
#define SYS_ID_TIMESTAMP 1477747345
#define SYS_ID_TYPE "altera_avalon_sysid_qsys"


/*
 * sys_timer configuration
 *
 */

#define ALT_MODULE_CLASS_sys_timer altera_avalon_timer
#define SYS_TIMER_ALWAYS_RUN 0
#define SYS_TIMER_BASE 0x9720
#define SYS_TIMER_COUNTER_SIZE 32
#define SYS_TIMER_FIXED_PERIOD 0
#define SYS_TIMER_FREQ 133333333
#define SYS_TIMER_IRQ 0
#define SYS_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYS_TIMER_LOAD_VALUE 133332
#define SYS_TIMER_MULT 0.0010
#define SYS_TIMER_NAME "/dev/sys_timer"
#define SYS_TIMER_PERIOD 1
#define SYS_TIMER_PERIOD_UNITS "ms"
#define SYS_TIMER_RESET_OUTPUT 0
#define SYS_TIMER_SNAPSHOT 1
#define SYS_TIMER_SPAN 32
#define SYS_TIMER_TICKS_PER_SEC 1000
#define SYS_TIMER_TIMEOUT_PULSE_OUTPUT 1
#define SYS_TIMER_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
