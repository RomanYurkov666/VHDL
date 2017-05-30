/*
 * test_generator.c
 *
 *  Created on: 23.10.2016
 *      Author: Igor
 */
#include "system.h"
#include "io.h"

typedef struct
{
  unsigned short delay;
  unsigned short len;
  unsigned char enable;
} test_pulse_parameter;

test_pulse_parameter test_pulses[6];

void test_pulse_generator_init()
{
   unsigned char i = 0;
   for (i=0;i<6;i++)
   {
	   test_pulses[i].len = 4;
	   test_pulses[i].enable = 1;
   }
   test_pulses[0].delay=10;
   test_pulses[1].delay=30;
   test_pulses[2].delay=70;
   test_pulses[3].delay=130;
   test_pulses[4].delay=250;
   test_pulses[5].delay=370;
}


void generate_test_pulses()
{
  unsigned int data;
  unsigned int buf;
  unsigned char i = 0;
  unsigned long int time = 0;
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
  time=read_sys_time_ms();
  while (time==read_sys_time_ms()) {}

}


