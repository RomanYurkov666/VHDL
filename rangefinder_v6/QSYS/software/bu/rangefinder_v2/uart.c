/*
 * uart.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "uart.h"

#define CPU_FREQ     133333333
#define PC_UART_SPEED   115200
#define PC_UART_DIVIDER ((CPU_FREQ/PC_UART_SPEED)+1)

void uart_init()
{

}

int send_uart(unsigned char byte, unsigned long base)
{
    IOWR_ALTERA_AVALON_UART_TXDATA (base, byte);
    while (!(IORD_ALTERA_AVALON_UART_STATUS(base)&ALTERA_AVALON_UART_STATUS_TMT_MSK));
    return 1;
}

int send_uart_n(unsigned char *msg, unsigned char length, unsigned long base)
{
	unsigned char i=0;
	for (i=0;i<length;i++) send_uart(msg[i], base);
    return 1;
}

int send_com2pc (unsigned char *msg, unsigned char length)
{
	send_uart_n(msg,length,PC_UART_BASE);
	return 1;
}


