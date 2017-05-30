/*
 * tdc.c
 *
 *  Created on: 23.10.2016
 *      Author: Igor
 */

#include "global.h"
#include "system.h"
#include "io.h"
#include "tdc.h"
#include "timer.h"
#include "spi.h"
#include "altera_avalon_pio_regs.h"

typedef struct
{
  unsigned int time;
  unsigned int counter;
} tdc_meas_result;

////////////¬Õ»Ã¿Õ»≈ œ≈–≈Œœ–≈ƒ≈À≈ÕÕ€… ¿ƒ–≈—
#define TDC_LONG_WORD_LEN 32
#define TDC_SHORT_WORD_LEN 16
#define TDC_CLK_DIV 13
#define TDC_CLK_POL 0
#define TDC_CLK_PH 0

//Registers addr
/*
00h CONFIG1 Configuration Register 1 8 00h
01h CONFIG2 Configuration Register 2 8 40h
02h INT_STATUS Interrupt Status Register 8 00h
03h INT_MASK Interrupt Mask Register 8 07h
04h COARSE_CNTR_OVF_H Coarse Counter Overflow Value High 8 FFh
05h COARSE_CNTR_OVF_L Coarse Counter Overflow Value Low 8 FFh
06h CLOCK_CNTR_OVF_H CLOCK Counter Overflow Value High 8 FFh
07h CLOCK_CNTR_OVF_L CLOCK Counter Overflow Value Low 8 FFh
08h CLOCK_CNTR_STOP_MASK_H CLOCK Counter STOP Mask High 8 00h
09h CLOCK_CNTR_STOP_MASK_L CLOCK Counter STOP Mask Low 8 00h
10h TIME1 Measured Time 1 24 00_0000h
11h CLOCK_COUNT1 CLOCK Counter Value 24 00_0000h
12h TIME2 Measured Time 2 24 00_0000h
13h CLOCK_COUNT2 CLOCK Counter Value 24 00_0000h
14h TIME3 Measured Time 3 24 00_0000h
15h CLOCK_COUNT3 CLOCK Counter Value 24 00_0000h
16h TIME4 Measured Time 4 24 00_0000h
17h CLOCK_COUNT4 CLOCK Counter Value 24 00_0000h
18h TIME5 Measured Time 5 24 00_0000h
19h CLOCK_COUNT5 CLOCK Counter Value 24 00_0000h
1Ah TIME6 Measured Time 6 24 00_0000h
1Bh CALIBRATION1 Calibration 1, 1 CLOCK Period 24 00_0000h
1Ch CALIBRATION2 Calibration 2, 2/10/20/40 CLOCK
Periods
24 00_0000h
*/

#define CONFIG1_ADDR 		0x0
#define CONFIG2_ADDR 		0x1
#define INT_STATUS 			0x2
#define INT_MASK			0x3
#define COARSE_CNTR_OVF_H	0x4
#define COARSE_CNTR_OVF_L	0x5
#define CLOCK_CNTR_OVF_H	0x6
#define CLOCK_CNTR_OVF_L	0x7
#define CLOCK_CNTR_STOP_MASK_H 0x8
#define CLOCK_CNTR_STOP_MASK_L 0x9
#define TIME1				0x10
#define CLOCK_COUNT1		0x11
#define TIME2				0x12
#define CLOCK_COUNT2		0x13
#define TIME3				0x14
#define CLOCK_COUNT3		0x15
#define TIME4				0x16
#define CLOCK_COUNT4		0x17
#define TIME5				0x18
#define CLOCK_COUNT5		0x19
#define TIME6				0x1A
#define CALIBRATION1		0x1B
#define CALIBRATION2		0x1C

//CONFIG REG 1 FIELS
#define FORCE_CAL 0x80
#define PARITY_EN 0x40
#define TRIGG_EDGE 0x20
#define STOP_EDGE 0x10
#define START_EDGE 0x8
#define START_MEAS 0x1
#define MEAS_MODE 0x2 //(2:1)=01 - Measurement mode 2 (recommended)

//CONFIG REG2 FIELDS
#define NUM_STOP 0x4 //5 ÒÚÓÔÓ‚

void write_16bword_to_tdc (unsigned char address, unsigned char tx_data);
unsigned char read_16bword_from_tdc (unsigned char address);
void write_32bword_to_tdc (unsigned char address, unsigned int tx_data);
unsigned int read_32bword_from_tdc (unsigned char address);

unsigned int rx_data[16];

tdc_meas_result tdc_result[6];


void write_16bword_to_tdc (unsigned char address, unsigned char tx_data)
{
	unsigned short tx_word = 0;
	unsigned int answer = 0;
	tx_word = tx_data;
	tx_word|=(address<<8);
	tx_word|=0x4000;
	answer=send_spi_word(SPI_TDC_BASE,tx_word<<16,TDC_SHORT_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
}

unsigned char read_16bword_from_tdc (unsigned char address)
{
	unsigned short tx_word = 0;
	unsigned int answer = 0;
	tx_word|=(address<<8);
	answer=send_spi_word(SPI_TDC_BASE,tx_word<<16,TDC_SHORT_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
	answer=(answer>>24);
	return answer;
}

void write_32bword_to_tdc (unsigned char address, unsigned int tx_data)
{
	unsigned short tx_word = 0;
	unsigned int answer = 0;
	tx_word = tx_data&0xffffff;
	tx_word|=(address<<24);
	tx_word|=0x40000000;
	answer=send_spi_word(SPI_TDC_BASE,tx_word,TDC_LONG_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
}

unsigned int read_32bword_from_tdc (unsigned char address)
{
	unsigned short tx_word = 0;
	unsigned int answer = 0;
	tx_word|=(address<<24);
	answer=send_spi_word(SPI_TDC_BASE,tx_word,TDC_LONG_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
	return answer;
}


void tdc_init()
{
	set_tdc_enable(1); //reset
	write_16bword_to_tdc(CONFIG2_ADDR,NUM_STOP);
	write_16bword_to_tdc(CONFIG1_ADDR,MEAS_MODE);
}

void tdc_test()
{
	unsigned short rxdata;
	rxdata=read_16bword_from_tdc(0x1);
}

void read_tdc_result()
{
   unsigned int data;

   rx_data[0]=read_32bword_from_tdc(0x10);
   rx_data[1]=read_32bword_from_tdc(0x12);
   rx_data[2]=read_32bword_from_tdc(0x14);
   rx_data[3]=read_32bword_from_tdc(0x16);
   rx_data[4]=read_32bword_from_tdc(0x18);

   data++;
}

void set_tdc_enable (unsigned char state)
{
	if (state)
		IOWR_ALTERA_AVALON_PIO_DATA(TDC_ENABLE_BASE,0x1);
	else
		IOWR_ALTERA_AVALON_PIO_DATA(TDC_ENABLE_BASE,0x0);
}

void start_tdc_measurement()
{
	unsigned long int start_time = read_sys_time_ms();
	set_tdc_enable(0); //reset
	while (read_sys_time_ms()<(start_time+2)) //delay 2 ms
	{}
	set_tdc_enable(1); //enable
	write_16bword_to_tdc(CONFIG2_ADDR,NUM_STOP);
	write_16bword_to_tdc(CONFIG1_ADDR,MEAS_MODE|START_MEAS);
}

void read_tdc_meas_data()
{
   unsigned int i = 0;
   for (i=0;i<6;i++)
   {
	   tdc_result[i].time=read_32bword_from_tdc(TIME1+2*i);
	   tdc_result[i].counter=read_32bword_from_tdc(TIME1+2*i+1);
   }
}

void ProcCmd_TDC (CmdPC *cmd)
{
	switch (cmd->data[0])
	{
	case 0: {//write operation by address cmd->data[1], data = data[2]|data[3];
			unsigned char addr = cmd->data[1];
			unsigned int word = (cmd->data[2])<<16;
			word|=(cmd->data[3]<<8);
			word|=cmd->data[4];
			if (addr>0x9) //≈ÒÎË Â„ËÒÚ ‰ÎËÌÌ˚È
				write_32bword_to_tdc(addr,word);
			else
				write_16bword_to_tdc(addr,word);
			} break;
	case 1: { //read operation
			CmdPC pack;
			unsigned char addr = cmd->data[1];
			unsigned int result = 0;
			if (addr>0x9)
				result = read_32bword_from_tdc (addr) & 0xffffff;
			else
				result = read_16bword_from_tdc (addr) & 0xff;
			pack.sign = 0x5B;
			pack.code = PCCOM_TDC;
			pack.dlen = 4;
			pack.data[0] = 0; //read answer
			pack.data[1] = addr;
			pack.data[2] = (result>>16)&0xFF;
			pack.data[3] = (result>>8)&0xff;
			pack.data[4] = result&0xff;
			send2pc_cmdpc(&pack);
			} break;
	}
}

