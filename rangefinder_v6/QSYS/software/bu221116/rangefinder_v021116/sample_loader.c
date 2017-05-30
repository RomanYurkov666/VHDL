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

struct sample_buffer_data
{
	unsigned short pulse_abs_coord;
	unsigned char sample_size;
	unsigned char ram_ptr;
	unsigned buffer_full :1;
	unsigned stop_detected :1;
};

struct pulse_data
{
	unsigned short abs_position;
	unsigned char amplitude;
	unsigned char width;
	unsigned char detected;
};

struct echo_signal_data
{
	unsigned char pulse_counter;
	unsigned short distance;
	struct pulse_data pulse[6];
};





unsigned char sample [256];
struct sample_buffer_data ram_buffer[6];
struct echo_signal_data signal;

unsigned char get_max (unsigned char *sample, unsigned char length);

void start_recording(unsigned char rec_delay)
{
	unsigned short ctrl = rec_delay;
	ctrl=(ctrl<<1)|BIT0;
	IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,ctrl);
}

unsigned int get_buffer_status()
{

}

void reset_ram_buffers()
{
   unsigned int i = 0;
   IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,0x3f<<9);
   for (i=0;i<256;i++) sample[i]=0;
   IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,0);
}

void reset_memory_master (unsigned char buf_num)
{
   unsigned int reg_buf = 0;
   reg_buf=IORD(SAMPLE_LOADER_BASE,CONTROL_REG);
   reg_buf&=(BIT0<<buf_num);
}

unsigned short read_abs_counter()
{
	unsigned short buf = 0;
	buf=IORD(SAMPLE_LOADER_BASE,ABS_CNT_REG);
	return buf;
}

void refresh_meas_data()
{
   unsigned int buf = 0;
   unsigned char i = 0;
   unsigned int j = 0;
   unsigned int word = 0;
   for (i=0;i<6;i++)
   {
	   buf = IORD(SAMPLE_LOADER_BASE,(START_RAM+i));
	   ram_buffer[i].ram_ptr=buf&0xff;
	   buf=buf>>8;
	   ram_buffer[i].stop_detected=buf&BIT0;
	   buf=buf>>1;
	   ram_buffer[i].buffer_full=buf&BIT0;
	   buf=buf>>1;
	   ram_buffer[i].sample_size=buf&0xff;
	   buf=buf>>8;
	   ram_buffer[i].pulse_abs_coord=buf&0x1fff;
	   //signal data
	   signal.pulse[i].abs_position=ram_buffer[i].pulse_abs_coord;
	   if (ram_buffer[i].stop_detected)
	   {
		   for (j=0;j<64;j++)
			   {
			   word=IORD(RAM_SAMPLE_0_BASE-(0x100*i),j);
			   sample[j*4]=word&0xff;
			   sample[j*4+1]=(word>>8)&0xff;
			   sample[j*4+2]=(word>>16)&0xff;
			   sample[j*4+3]=(word>>24)&0xff;
			   }
		   signal.pulse[i].amplitude=get_max(sample,ram_buffer[i].sample_size);
		   signal.pulse[i].detected=ram_buffer[i].stop_detected;
	   }
   }
}

unsigned char get_max (unsigned char *sample, unsigned char length)
{
  unsigned int i = 0;
  unsigned char max = 0;
  for (i=0;i<length;i++)
	  if (sample[i]>max) max=sample[i];
  return max;
}
