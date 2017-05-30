/*
 * stepper_controller.c
 *
 *  Created on: 02.12.2016
 *      Author: user
 */
#include "io.h"
#include "system.h"
#include "stepper_controller.h"
#include "global.h"


#define CONTROL_REG_ADDR 0x0
#define POSITION_REG_ADDR 0x1
#define SPEED_REG_ADDR 0x2
#define DISTANCE_REG_ADDR 0x3

void start_moving(unsigned int base, unsigned char dir, unsigned int speed_div)
{
	unsigned int buf = 0;
	buf = speed_div;
	IOWR(base, SPEED_REG_ADDR, buf); //speed
	buf = BIT0; //start moving
	buf &= ~BIT1; //mode - unlimited
	if (dir)
		buf|=BIT2; //direction
	IOWR(base, CONTROL_REG_ADDR, buf);
}

void stop_moving(unsigned int base)
{
	unsigned int buf = 0;
	IOWR(base, CONTROL_REG_ADDR, buf);
}

void move_on_distance(unsigned int base, unsigned char dir, unsigned int speed_div, unsigned int distance)
{
	unsigned int buf = 0;
	buf = speed_div;
	IOWR(base, SPEED_REG_ADDR, buf); //speed
	buf = distance;
	IOWR(base, DISTANCE_REG_ADDR, buf); //distance
	buf = BIT0; //start moving
	buf |= BIT1; //mode - limited
	if (dir)
		buf|=BIT2; //direction
	IOWR(base, CONTROL_REG_ADDR, buf);
}

unsigned int current_pos(unsigned int base)
{
	unsigned int pos = 0;
	pos = IORD(base,POSITION_REG_ADDR);
	return pos;
}

void reset_position(unsigned int base)
{
	unsigned int reset = 0x1;
	IOWR(base, POSITION_REG_ADDR, reset);
}

