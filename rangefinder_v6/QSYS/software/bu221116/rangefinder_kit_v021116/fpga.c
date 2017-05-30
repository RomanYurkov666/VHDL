/*
 * fpga.c
 *
 *  Created on: 14.11.2016
 *      Author: user
 */
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "global.h"


unsigned char mode = 0;

void ProcCmdFPGA (CmdPC *cmd);


void ProcCmdFPGA (CmdPC *cmd)
{
	mode=cmd->data[0];
	if (cmd->data[0])
		IOWR_ALTERA_AVALON_PIO_DATA(SYSTEM_MODE_BASE,mode);
	else
		IOWR_ALTERA_AVALON_PIO_DATA(SYSTEM_MODE_BASE,mode);
}

