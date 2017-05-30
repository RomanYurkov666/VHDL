/*
 * laser.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */
#include "system.h"
#include "global.h"
#include "io.h"

#define DRIVER_CONTROL    0x0
#define DRIVER_STATUS     0x1
#define PULSE_LENGTH      0x2
#define PULSE_DELAY       0x3
#define PULSE_BACK_DELAY  0x4

//Module - generator of laser enable strobe
//3 modes:
//00: Start by CPU (with delay), stop after external comparator signal;
//01: Start by CPU (with delay), strobe length equivalent to "pulse length"
//10: Start by CPU (with delay), stop after external comparator signal (strobe length is limited by "pulse length");
//11: Start by CPU (with delay), stop after external comparator signal (with delay)

void laser_init()
{
	IOWR(LASER_DRIVER_BASE,2,10);
	IOWR(LASER_DRIVER_BASE,3,2);
}

void generate_pulse(unsigned short tpulse)
{
   //mode - 0b01 control[2:1]
   IOWR(LASER_DRIVER_BASE,PULSE_LENGTH,tpulse);
   IOWR(LASER_DRIVER_BASE,PULSE_DELAY,0);
   IOWR(LASER_DRIVER_BASE,DRIVER_CONTROL,0x3);
}

