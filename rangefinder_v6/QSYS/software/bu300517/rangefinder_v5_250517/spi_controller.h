/*
 * spi_controller.h
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#ifndef SPI_CONTROLLER_H_
#define SPI_CONTROLLER_H_

#define START_BIT           0x1
#define CLK_POLARITY_BIT 	0x2
#define CLK_PHASE_BIT 		0x4

#define CONTROL_REG_ADDR 	0x0
#define STATUS_REG_ADDR 	0x1
#define TX_DATA_REG_ADDR    0x2
#define RX_DATA_REG_ADDR    0x3

unsigned int send_spi_word(unsigned int module_base, unsigned int tx_data, unsigned char len_bits, unsigned char clk_div, unsigned char clk_pol, unsigned char clk_phase);


#endif /* SPI_CONTROLLER_H_ */
