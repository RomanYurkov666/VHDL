/*
 * spi.c
 *
 *  Created on: 14.11.2016
 *      Author: user
 */

#include "io.h"

#define START_BIT           0x1
#define CLK_POLARITY_BIT 	0x2
#define CLK_PHASE_BIT 		0x4

#define CONTROL_REG_ADDR 	0x0
#define STATUS_REG_ADDR 	0x1
#define TX_DATA_REG_ADDR    0x2
#define RX_DATA_REG_ADDR    0x3


unsigned int send_spi_word(unsigned int module_base, unsigned int tx_data, unsigned char len_bits, unsigned char clk_div, unsigned char clk_pol, unsigned char clk_phase)
{
	unsigned int buf = 0;
	unsigned char ready = 0;
	unsigned long int time_start = 0;
	buf=tx_data;
	IOWR(module_base,TX_DATA_REG_ADDR,buf);
	if (clk_pol)
		buf|=CLK_POLARITY_BIT;
	if (clk_phase)
		buf|=CLK_PHASE_BIT;
	buf|=(len_bits<<3);
	buf|=(clk_div<<11);
	IOWR(module_base,CONTROL_REG_ADDR,buf);
	buf|=START_BIT;
	IOWR(module_base,CONTROL_REG_ADDR,buf);
	time_start = read_sys_time_ms() + 1;
	while (!ready) //while module is not ready
	{
		buf=IORD(module_base,STATUS_REG_ADDR);
		if (buf) //if ready
			ready = 1;
		else if (time_start>read_sys_time_ms()) //гарантированный туйм-аут по 2 мс
			ready = 1;
	}
	buf=IORD(module_base,RX_DATA_REG_ADDR);
	return buf;
}
