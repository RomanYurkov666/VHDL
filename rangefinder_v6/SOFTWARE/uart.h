/*
 * uart.h
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

int send_uart(unsigned char byte, unsigned long base);
int send_uart_n(unsigned char *msg, unsigned char length, unsigned long base);
int send_com2pc (unsigned char *msg, unsigned char length);
