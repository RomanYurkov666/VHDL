/*
 * ad8369.c
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#include "system.h"
#include "pc_com.h"
#include "spi_controller.h"
#include "ad8369.h"

unsigned char current_vga_gain = min5db;

void ProcCmd_VGA(t_pc_cmd *cmd);

void ProcCmd_VGA(t_pc_cmd *cmd)
{
	current_vga_gain=cmd->data[0];
	set_VGA_gain(current_vga_gain);
}

void set_VGA_gain(unsigned char gain)
{
	unsigned int tx_word = 0;
	unsigned int answer = 0;
	tx_word = gain & 0xF;
	tx_word = tx_word << 28;
	answer=send_spi_word(SPI_VGA_BASE,tx_word,VGA_WORD_LEN,VGA_CLK_DIV,VGA_CLK_POL,VGA_CLK_PH);
}

