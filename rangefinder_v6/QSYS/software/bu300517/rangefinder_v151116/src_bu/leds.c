/*
 * leds.c
 *
 *  Created on: 27.05.2016
 *      Author: user
 */

#include "global.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "accelerometer.h"

unsigned char leds_status = BIT3|BIT4;
unsigned char rigth_blink = 0;
unsigned char left_blink = 0;

unsigned char direction = 0;
unsigned char shift = 0;
unsigned char blinky_flag = 0;
unsigned char blinky_status = 0;

unsigned char axis_num = 0;

unsigned char counter = 0;
#define PERIOD 100

void change_axis()
{
	axis_num++;
	if (axis_num>2) axis_num=0;
}

void leds_init()
{
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PORT_BASE, leds_status);
}

void leds_driver()
{
	unsigned short coordinate = 0;
	unsigned char shift = 0;

	switch (axis_num)
	{
	case 0: coordinate=get_x_coord(); break;
	case 1: coordinate=get_y_coord(); break;
	case 2: coordinate=get_z_coord(); break;
	}

	coordinate=(coordinate>>5)&0xFF;

	direction=(coordinate&BIT7)?0:1; //if negative direction = 0
	coordinate=(direction)?(coordinate&0xff):((~coordinate)&0xff); //if negative - inverse
	shift=(coordinate>>1)&0x7;
	leds_status=(direction)?((BIT3|BIT4)<<shift):((BIT3|BIT4)>>shift);
	blinky_flag=((coordinate>>1)>3);

	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PORT_BASE, leds_status);
}
