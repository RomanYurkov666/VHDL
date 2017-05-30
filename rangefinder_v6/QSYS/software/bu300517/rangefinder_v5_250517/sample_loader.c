/*
 * sample_loader.c
 *
 *  Created on: 23.11.2016
 *      Author: user
 */
/*
#include "global.h"
#include "system.h"
#include "io.h"
#include "pc_com.h"
#include "sample_loader.h"
#include "string.h"

void ProcCmd_SampleLoader (t_pc_cmd *cmd);
void start_sample_record(unsigned char rec_delay);
void stop_sample_record();
void send_sample(unsigned char sample);
void refresh_meas_data();

unsigned char selected_sample [256];

echo_signal_data signal;
sample_buffer_data ram_data[6];


void ProcCmd_SampleLoader (t_pc_cmd *cmd)
{
	switch (cmd->data[0])
	{
	case start_sample:
		start_sample_record(cmd->data[1]); //record delay
		break;
	case stop_sample: //stop record
		stop_sample_record();
		refresh_meas_data();
		break;
	case read_sample: //get sample
		send_sample(cmd->data[1]);
		break;
	}
}

void start_sample_record(unsigned char rec_delay)
{
	unsigned short ctrl = rec_delay;
	ctrl=(ctrl<<1)|BIT0;
	IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,ctrl);
}

void stop_sample_record()
{
	unsigned short ctrl = 0;
	IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,ctrl);
}

void reset_ram_buffers()
{
   IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,0x3f<<9);
   memset(selected_sample,0,sizeof(selected_sample));
   IOWR(SAMPLE_LOADER_BASE,CONTROL_REG,0);
}

void send_sample(unsigned char sample)
{
	t_pc_cmd pack;
	unsigned char i = 0;
	for (i=0;i<8;i++)
	{
		unsigned char *ptr = (unsigned char*)signal.pulse[sample].sample;
		memcpy(pack.data+1,ptr+i*32,32);
		pack.sign=0x5B;
		pack.dlen=33; //1 byte for subframe number
		pack.data[0]=i;
		pack.code=PCCOM_SAMPLE_LOADER;
		send_cmd2pc(&pack);
	}
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
	   ram_data[i].ram_ptr=buf&0xff;
	   buf=buf>>8;
	   ram_data[i].stop_detected=buf&BIT0;
	   buf=buf>>1;
	   ram_data[i].buffer_full=buf&BIT0;
	   buf=buf>>1;
	   ram_data[i].sample_size=buf&0xff;
	   buf=buf>>8;
	   ram_data[i].pulse_abs_coord=buf&0x1fff;
	   //signal data
	   signal.pulse[i].abs_position=ram_data[i].pulse_abs_coord;
	   //На этапе отладки убираем//if (ram_data[i].stop_detected)
	   {
		   for (j=0;j<64;j++)
			   {
			   word=IORD(RAM_SAMPLE_0_BASE-(0x100*i),j);
			   signal.pulse[i].sample[j*4]=word&0xff;
			   signal.pulse[i].sample[j*4+1]=(word>>8)&0xff;
			   signal.pulse[i].sample[j*4+2]=(word>>16)&0xff;
			   signal.pulse[i].sample[j*4+3]=(word>>24)&0xff;
			   }
		   //signal.pulse[i].amplitude=get_max(signal.pulse[i].sample,ram_data[i].sample_size);
		   signal.pulse[i].detected=ram_data[i].stop_detected;
	   }
   }
}

alt_u8* get_sample(alt_u8 num)
{
	return signal.pulse[num].sample;
}
*/
