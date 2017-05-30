/*
 * pulse_generator.c
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#include "system.h"
#include "io.h"
#include "pulse_generator.h"
#include "pc_com.h"


test_pulse_parameter test_pulses[6];

void ProcCmd_PulseGen (t_pc_cmd *cmd);

void init_pulse_generator()
{
	unsigned char i = 0;
	for (i=0;i<6;i++)
	{
	   test_pulses[i].len = 2;
	   test_pulses[i].enable = 1;
	}
	test_pulses[0].delay=10;
	test_pulses[1].delay=30;
	test_pulses[2].delay=70;
	test_pulses[3].delay=130;
	test_pulses[4].delay=250;
	test_pulses[5].delay=370;
}

void ProcCmd_PulseGen (t_pc_cmd *cmd)
{
	unsigned char pulsindex = cmd->data[0];
	unsigned short buf;
	if (pulsindex < 6)
	{
		test_pulses[pulsindex].enable=cmd->data[1];
		buf=(cmd->data[3]<<8)|cmd->data[2];
		test_pulses[pulsindex].len=buf;
		buf=(cmd->data[5]<<8)|cmd->data[4];
		test_pulses[pulsindex].delay=buf;
	}
	else
		generate_test_pulses();
}

void generate_test_pulses()
{
	unsigned int data;
	unsigned int buf;
	unsigned char i = 0;
	for (i=0;i<6;i++)
	{
	  data=test_pulses[i].delay;
	  buf=(test_pulses[i].len<<16)&0x7FFF0000;
	  data|=buf;
	  if (test_pulses[i].enable)
	  data|=0x80000000;
	  IOWR(PULSE_GENERATOR_BASE,i+1,data); //pulses parameters
	}
	IOWR(PULSE_GENERATOR_BASE,0,0x1); //control, start
}
