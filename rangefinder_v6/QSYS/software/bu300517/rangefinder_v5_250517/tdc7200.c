/*
 * tdc7200.c
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#include "global.h"
#include "system.h"
#include "uart.h"
#include "tdc7200.h"
#include "spi_controller.h"
#include "pc_com.h"
#include "altera_avalon_pio_regs.h"
#include "time.h"

void write_16bword_to_tdc (unsigned char address, unsigned char tx_data);
unsigned char read_16bword_from_tdc (unsigned char address);
void write_32bword_to_tdc (unsigned char address, unsigned int tx_data);
unsigned int read_32bword_from_tdc (unsigned char address);

void tdc_pause(unsigned short ticks);
void ProcCmd_TDC(t_pc_cmd *cmd);
void TDC7200_reg_init();
void tdc_start_measure();
void tdc_stop_measure();

unsigned int tdc_results[5];

unsigned char TDC7200_reg_local_copy[10] = {0x02, 0x44, 0x07, 0x07, 0xFF, 0xFF, 0xFF, 0xFF, 0x0, 0x0 };//0x44, 0x07, 0x07, 0xFF, 0xFF, 0xFF, 0xFF, 0x0, 0x0 };
//0x41 потому что 2 стопа, а не 5 как было

void Init_TDC7200(void)
{
	set_tdc_chip_enable(disable);//TDC7200_ENABLE_PxOUT |= TDC7200_ENABLE_PIN;// Enable TDC7200
	tdc_pause(5);
	//UCB1CTLW0 &= ~UCSWRST;// Switch on SPI module
	set_tdc_chip_enable(enable);//TDC7200_ENABLE_PxOUT |= TDC7200_ENABLE_PIN;// Enable TDC7200
	tdc_pause(5);

	//tdc7200_reset(); //delay_uS(TDC7200_WAKEUP_PERIOD); // Reset TDC7200
	TDC7200_reg_init();									// init registers of TDC7200
	//TDC7200_ENABLE_PxOUT &= ~TDC7200_ENABLE_PIN;		// Enable TDC7200 ????????????
	memset(tdc_results,0,sizeof(tdc_results));
}


void ProcCmd_TDC(t_pc_cmd *cmd)
{
	switch(cmd->data[0])
	{
	case write_reg:
			{
			unsigned char addr = cmd->data[1];
			unsigned int word = (cmd->data[2])<<16;
			word|=(cmd->data[3]<<8);
			word|=cmd->data[4];
			if (addr>0x9) //Если регистр длинный
				write_32bword_to_tdc(addr,word);
			else
				write_16bword_to_tdc(addr,word);
			}
		break;
	case read_reg:
			{
			t_pc_cmd pack;
			unsigned char addr = cmd->data[1];
			unsigned int result = 0;
			if (addr>0x9)
				result = read_32bword_from_tdc (addr) & 0xffffff;
			else
				result = read_16bword_from_tdc (addr) & 0xff;
			pack.sign = 0x5B;
			pack.code = PCCOM_TDC;
			pack.dlen = 5;
			pack.data[0] = 0; //read answer
			pack.data[1] = addr;
			pack.data[2] = (result>>16)&0xFF;
			pack.data[3] = (result>>8)&0xff;
			pack.data[4] = result&0xff;
			send_cmd2pc(&pack);
			}
		break;
	case reset_chip:
		tdc7200_reset();
		break;
	case start_measure:
		tdc_start_measure();
		break;
	case stop_measure:
		tdc_stop_measure();
		break;
	case init_chip:
		Init_TDC7200();
		break;
	}
}


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
	answer&=0xFF; //Младший байт
	return answer;
}

void write_32bword_to_tdc (unsigned char address, unsigned int tx_data)
{
	unsigned int tx_word = 0;
	unsigned int answer = 0;
	tx_word = tx_data&0xffffff;
	tx_word|=(address<<24);
	tx_word|=0x40000000;
	answer=send_spi_word(SPI_TDC_BASE,tx_word,TDC_LONG_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
}

unsigned int read_32bword_from_tdc (unsigned char address)
{
	unsigned int tx_word = 0;
	unsigned int answer = 0;
	tx_word|=(address<<24);
	answer=send_spi_word(SPI_TDC_BASE,tx_word,TDC_LONG_WORD_LEN,TDC_CLK_DIV,TDC_CLK_POL,TDC_CLK_PH);
	answer&=0xffffff; //Младшие 3 байта
	return answer;
}

void set_tdc_chip_enable(unsigned char nReset)
{
	if (nReset)
		 IOWR_ALTERA_AVALON_PIO_DATA(TDC_ENABLE_BASE, 0x1); //enable
	else
		IOWR_ALTERA_AVALON_PIO_DATA(TDC_ENABLE_BASE, 0x0); //disable
}

void tdc7200_reset()
{
	set_tdc_chip_enable(disable);
	tdc_pause(1);
	set_tdc_chip_enable(enable);
	tdc_pause(1);
}

void tdc_pause(unsigned short ticks)
{
	unsigned char ready = 0;
	unsigned short delay = 0;
	sys_timer_flags()->tdc=0;
	while (!ready)
	{
		if (sys_timer_flags()->tdc)
			{
			sys_timer_flags()->tdc=0;
			delay++;
			}
		if (delay>ticks)
			ready=1;
	}
}

void TDC7200_reg_init()
{
	unsigned char i = 0;
	for (i=0;i<sizeof(TDC7200_reg_local_copy);i++)
		write_16bword_to_tdc(i,TDC7200_reg_local_copy[i]);
}

void tdc_start_measure()
{
	write_16bword_to_tdc(INT_STATUS,0x1F);
	TDC7200_reg_local_copy[CONFIG1_ADDR]|=BIT0;
	write_16bword_to_tdc(CONFIG1_ADDR,TDC7200_reg_local_copy[CONFIG1_ADDR]);
}

void tdc_stop_measure()
{
	unsigned char i = 0;
	for (i=0;i<5;i++)
		tdc_results[i]=read_16bword_from_tdc(TIME1+2*i);
}
