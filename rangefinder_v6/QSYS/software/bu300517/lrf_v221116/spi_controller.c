/*
 * spi_controller.c
 *
 *  Created on: 22.11.2016
 *      Author: user
 */


#include "io.h"
#include "spi_controller.h"
#include "time.h"


unsigned int send_spi_word(unsigned int module_base, unsigned int tx_data, unsigned char len_bits, unsigned char clk_div, unsigned char clk_pol, unsigned char clk_phase)
{
	unsigned int buf = 0;
	unsigned char ready = 0;
	unsigned char timeout = 0;
	buf=tx_data;
	IOWR(module_base,TX_DATA_REG_ADDR,buf);
	buf = 0;
	if (clk_pol)
		buf|=CLK_POLARITY_BIT;
	if (clk_phase)
		buf|=CLK_PHASE_BIT;
	buf|=(len_bits<<3);
	buf|=(clk_div<<11);
	IOWR(module_base,CONTROL_REG_ADDR,buf);
	buf|=START_BIT;
	IOWR(module_base,CONTROL_REG_ADDR,buf);
	sys_timer_flags()->spi_module=0; //reset timer flag
	while (!ready) //while module is not ready
	{
		buf=IORD(module_base,STATUS_REG_ADDR);
		if (buf) //if ready
			ready = 1;
		else if (sys_timer_flags()->spi_module) //гарантированный туйм-аут по 2 мс
			{
			sys_timer_flags()->spi_module=0;
			timeout++;
			}
		if (timeout>1)
			ready = 1;
	}
	buf=IORD(module_base,RX_DATA_REG_ADDR);
	return buf;
}

