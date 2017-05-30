/*
 * sample_recorder.c
 *
 *  Created on: 29.05.2017
 *      Author: user
 */

#include "system.h"
#include "io.h"
#include "sample_recorder.h"
#include "time.h"
#include "string.h"
#include "pc_com.h"

t_sample_recorder_config sr_config;
t_recording_channel adc_channel[6];
alt_u8 G_recording_in_process = 0;
alt_u16 timeout_counter = 0;
alt_u16 timeout_set_ms = 10;

void config_sample_recorder(t_sample_recorder_config* c);
void read_sample (alt_u8 sample_num);
void reset_adc_modules();

void debug_point();
void test_call_generator();

#define SAMPLE_RECORDER_AVALON_SLAVE_BASE 0x9100
#define SAMPLE_RECORDER_AVALON_SLAVE_1_BASE 0x9000

void init_sample_recorder()
{
	alt_16 i = 0;

	sr_config.config_base = SAMPLE_RECORDER_AVALON_SLAVE_BASE;
	sr_config.ram_base = SAMPLE_RECORDER_AVALON_SLAVE_1_BASE;

	sr_config.start_recording=0;
	sr_config.stop_recording=0;
	sr_config.complete=0;
	sr_config.start_loading_to_ram=0;

	sr_config.active_channel=0x0;
	sr_config.recording_delay=64;

	sr_config.trigger_direction=trigger_posedge;
	sr_config.trigger_source=external_comparator;
	sr_config.trigger_threshold=DEFAULT_COMPARATOR_LEVEL;

	config_sample_recorder(&sr_config);

	for (i=0;i<6;i++)
	{
		adc_channel[i].amplitude=0x0;
		adc_channel[i].distance=0x0;
		adc_channel[i].pulse_detected=0x0;
		adc_channel[i].sample_len=0x0;
		adc_channel[i].timestamp=0x0;
		adc_channel[i].width=0x0;
		memset(adc_channel[i].sample,0,sizeof(adc_channel[i].sample));
	}
}

void config_sample_recorder(t_sample_recorder_config* c)
{
	alt_u32 wdata = 0x0;
	//control_1_reg
	if (c->start_recording)
	{
		c->start_recording=0; //reset flag
		IOWR(c->config_base,control_1_reg,0x1); //start pulse
	}
	if (c->stop_recording)
	{
		c->stop_recording=0; //reset flag
		IOWR(c->config_base,control_1_reg,0x0); //stop pulse
	}

	//control_0_reg
	wdata |= ((alt_u32)sr_config.trigger_threshold)<<TRIGGER_THRESHOLD_OFFSET;
	wdata |= ((alt_u32)sr_config.recording_delay)<<RECORDING_DELAY_OFFSET;
	wdata |= ((alt_u32)sr_config.active_channel)<<ACTIVE_CHANNEL_SET_OFFSET;
	wdata |= (sr_config.complete)?COMPLETE_RECORD_BIT:0x0;
	wdata |= (sr_config.start_loading_to_ram)?LOAD_DATA_TO_RAM_BIT:0x0;
	wdata |= (sr_config.trigger_direction)?TRIGGER_DIRECTION_BIT:0x0;
	wdata |= (sr_config.trigger_source)?TRIGGER_SOURCE_BIT:0x0;
	IOWR(c->config_base,control_0_reg,wdata);

	sr_config.start_loading_to_ram=0; //reset flag
	sr_config.complete=0; //reset flag
}

void read_sample (alt_u8 sample_num)
{
	alt_16 i = 0;
	alt_u32 *ptr_32bit = NULL;
	alt_u32 status = 0x0;

	//read sample from fifo
	sr_config.active_channel = sample_num;
	config_sample_recorder(&sr_config);
	sr_config.start_loading_to_ram = 1;
	config_sample_recorder(&sr_config);
	simple_delay(2000);

	ptr_32bit=(alt_u32*)adc_channel[sample_num].sample;
	for (i=0;i<64;i++)
	{
		ptr_32bit[i]=IORD(sr_config.ram_base,i);
	}

	//read channel data from registers
	status = IORD(sr_config.config_base,sample_num+3);
	adc_channel[sample_num].pulse_detected=status&0x1;
	adc_channel[sample_num].sample_len=(status>>1)&0xff;
	adc_channel[sample_num].timestamp=status>>9;
}

alt_u8* get_sample(alt_u8 num)
{
	return adc_channel[num].sample;
}

void sample_recorder_routine()
{
	//test_call_generator();

	//called every 1 ms
	if (G_recording_in_process)
	{
		timeout_counter++;
		if (timeout_counter>timeout_set_ms) //2 ms timeout
		{
			timeout_counter = 0;
			stop_sample_recorder();
			//debug_point();
		}
	}
}

void start_sample_recorder(alt_u16 timeout)
{
	sr_config.complete=1;
	config_sample_recorder(&sr_config);
	sr_config.start_recording = 1;
	config_sample_recorder(&sr_config);
	G_recording_in_process = 1;
	timeout_set_ms = timeout;
}

void stop_sample_recorder()
{
	alt_16 i = 0;
	sr_config.stop_recording = 1;
	config_sample_recorder(&sr_config);
	for (i=0;i<6;i++)
		read_sample(i);
	sr_config.complete = 1;
	config_sample_recorder(&sr_config);
	G_recording_in_process = 0;
}

void reset_adc_modules()
{
	sr_config.complete=1;
	config_sample_recorder(&sr_config);
}

void ProcCmd_SampleRecorder (t_pc_cmd *cmd)
{
	switch (cmd->data[0])
	{
	case cmd_start_recording:
		start_sample_recorder(10);
		//start_sample_record(cmd->data[1]); //record delay
		break;
	case cmd_stop_recording: //stop record //ÍÅ ÍÓÆÍÀ
		//stop_sample_recorder();
		//stop_sample_record();
		//refresh_meas_data();
		break;
	case cmd_read_sample: //get sample
		send_sample(cmd->data[1]);
		break;
	}
}

void send_sample(unsigned char sample)
{
	t_pc_cmd pack;
	unsigned char i = 0;
	for (i=0;i<8;i++)
	{
		unsigned char *ptr = (unsigned char*)adc_channel[sample].sample;
		memcpy(pack.data+1,ptr+i*32,32);
		pack.sign=0x5B;
		pack.dlen=33; //1 byte for subframe number
		pack.data[0]=i;
		pack.code=PCCOM_SAMPLE_LOADER;
		send_cmd2pc(&pack);
	}
}

//Debug****************************************************************************
void test_call_generator()
{
	static alt_u32 cnt = 0;
	cnt++;
	if (cnt>10)
	{
		cnt = 0;
		start_sample_recorder(2);
	}
}

void debug_point()
{
	alt_u32 i = 0;
	i++;
	if (i<15)
		i=15;
	i++;
}
