/*
 * tdc.h
 *
 *  Created on: 23.10.2016
 *      Author: Igor
 */

#ifndef TDC_H_
#define TDC_H_

void read_tdc_result();
unsigned int send_data_2_spi(unsigned int tx_data, unsigned char clk_div,
		                    unsigned char datalen, unsigned char clk_pol, unsigned char clk_phase);
void tdc_init();
void tdc_test();

#endif /* TDC_H_ */
