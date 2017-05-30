/*
 * sample_loader.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */
#include "system.h"
#include <io.h>
#include "global.h"

#define SAMPLE_LOADER_BASE 0x9600
#define CONTROL_REG    0x0
#define PULSE_CNT_REG  0x1
#define ABS_CNT_REG    0x2
#define START_RAM      0x3
#define STOP0_RAM      0x4
#define STOP1_RAM      0x5
#define STOP2_RAM      0x6
#define STOP3_RAM      0x7
#define STOP4_RAM      0x8

void start_recording(unsigned char rec_delay)
{
	unsigned short ctrl = rec_delay;
	ctrl=(ctrl<<1)|BIT0;
	IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,ctrl);
}
