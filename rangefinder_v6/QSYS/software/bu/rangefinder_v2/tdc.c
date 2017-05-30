/*
 * tdc.c
 *
 *  Created on: 23.10.2016
 *      Author: Igor
 */

#include "system.h"
#include "io.h"
#include "tdc.h"
#include "timer.h"

#define SPI_CONTROLLER_BASE 0x9750
////////////бмхлюмхе оепенопедекеммши юдпея

unsigned int send_data_2_spi(unsigned int tx_data, unsigned char clk_div,
		                    unsigned char datalen, unsigned char clk_pol, unsigned char clk_phase)
{
   unsigned int set = 0;
   unsigned int data = 0;
   unsigned int buf = 0;
   unsigned long int time_start = 0;
   unsigned int rx_result;

   if (clk_pol) set|=0x2;
   if (clk_phase) set|=0x4;
   set=datalen<<3;
   set|=buf;
   buf=clk_div<<11;
   set|=buf;
   IOWR(SPI_CONTROLLER_BASE,0,set);

   data = tx_data;
   IOWR(SPI_CONTROLLER_BASE,2,data);

   set|=0x1;
   IOWR(SPI_CONTROLLER_BASE,0,set);

   time_start = read_sys_time_ms();
   time_start++;
   while (time_start>read_sys_time_ms()) {}

   rx_result=IORD(SPI_CONTROLLER_BASE,3);

   return rx_result;
}

void tdc_init()
{
	unsigned short data;
	unsigned short addr;
	data=0x4|(0x1<<6); //data
	addr=0x1<<6; //wr
	addr|=0x1;   //addr
	data|=(addr<<8);
	send_data_2_spi(data<<16,13,16,0,0);
	data=0x3;
	addr=0x1<<6; //wr
	addr|=0x0; //addr
	data|=(addr<<8);
	send_data_2_spi(data<<16,13,16,0,0);
}

void tdc_test()
{
	unsigned short data;
	unsigned short rxdata;
	//data=(0x1<<6)|0x4; //DATA
	//data|=(0x1)<<8; //CONFIG1 REG ADDR
	//data|=0x4000; //wr
	data=0x0100;
	rxdata=send_data_2_spi(data<<16,13,16,0,0);
	data++;
	//data=3;
	//data|=0x4000; //wr
	//send_data_2_spi(data<<16,13,16,0,0);
}

void read_tdc_result()
{
   unsigned int data;
   unsigned int rx_data[16];

   data=0x10<<24;
   rx_data[0]=(send_data_2_spi(data,13,32,0,0))&0xFFFFFF;
   data=0x12<<24;
   rx_data[1]=(send_data_2_spi(data,13,32,0,0))&0xFFFFFF;
   data=0x14<<24;
   rx_data[2]=(send_data_2_spi(data,13,32,0,0))&0xFFFFFF;
   data=0x16<<24;
   rx_data[3]=(send_data_2_spi(data,13,32,0,0))&0xFFFFFF;
   data=0x18<<24;
   rx_data[4]=(send_data_2_spi(data,13,32,0,0))&0xFFFFFF;

   data++;
}
