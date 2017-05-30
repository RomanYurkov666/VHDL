/*
 * spi.h
 *
 *  Created on: 14.11.2016
 *      Author: user
 */

#ifndef SPI_H_
#define SPI_H_

unsigned int send_spi_word(unsigned int module_base, unsigned int tx_data, unsigned char len_bits, unsigned char clk_div, unsigned char clk_pol, unsigned char clk_phase);


#endif /* SPI_H_ */
