/*
 * max1932.c
 *
 *  Created on: 28.11.2016
 *      Author: user
 */

#include "system.h"
#include "pc_com.h"
#include "spi_controller.h"
#include "max1932.h"

unsigned char current_voltage = 0;

void ProcCmd_APD(t_pc_cmd *cmd);

void ProcCmd_APD(t_pc_cmd *cmd)
{
	current_voltage=cmd->data[0];
	set_APD_ref_source(current_voltage);
}

void set_APD_ref_source(unsigned char voltage)
{
	unsigned int tx_word = 0;
	unsigned int answer = 0;
	tx_word = voltage;
	tx_word = tx_word << 24;
	answer=send_spi_word(SPI_APD_BASE,tx_word,APD_WORD_LEN,APD_CLK_DIV,APD_CLK_POL,APD_CLK_PH);
}
