/*
 * sample_recorder.h
 *
 *  Created on: 29.05.2017
 *      Author: user
 */

#ifndef SAMPLE_RECORDER_H_
#define SAMPLE_RECORDER_H_

#include "alt_types.h"

#define DEFAULT_COMPARATOR_LEVEL 230

typedef enum
{
	control_0_reg = 		0x0, //config
	control_1_reg = 		0x1, //start/stop
	status_reg = 			0x2,
	channel_0_info_reg = 	0x3,
	channel_1_info_reg = 	0x4,
	channel_2_info_reg = 	0x5,
	channel_3_info_reg = 	0x6,
	channel_4_info_reg = 	0x7,
	channel_5_info_reg = 	0x8
} t_sample_recorder_registers_addresses;

#define START_STOP_BIT 				0x1

#define LOAD_DATA_TO_RAM_BIT 		0x1
#define COMPLETE_RECORD_BIT 		0x2
#define TRIGGER_SOURCE_BIT			0x4
#define ACTIVE_CHANNEL_SET_OFFSET	3
#define TRIGGER_THRESHOLD_OFFSET	6
#define TRIGGER_DIRECTION_BIT		0x4000
#define RECORDING_DELAY_OFFSET		15

typedef struct
{
	alt_u8 start_recording;
	alt_u8 stop_recording;
	alt_u8 start_loading_to_ram;
	alt_u8 complete;
	alt_u8 trigger_source;
	alt_u8 active_channel;
	alt_u8 trigger_threshold;
	alt_u8 trigger_direction;
	alt_u8 recording_delay;
	alt_u32 config_base;
	alt_u32 ram_base;
} t_sample_recorder_config;

typedef struct
{
	alt_u8 pulse_detected;
	alt_u8 sample_len;
	alt_u16 timestamp;
	alt_u8 amplitude;
	alt_u8 width;
	alt_u32 distance;
	alt_u8 sample[256];
} t_recording_channel;

typedef enum
{
	trigger_posedge = 0x1,
	trigger_negedge = 0x0
} t_trigger_directions;

typedef enum
{
	external_comparator = 0x0,
	internal_comparator = 0x1
} t_trigger_source;

typedef enum
{
  cmd_start_recording = 0x0,
  cmd_stop_recording = 0x1,
  cmd_read_sample = 0x2
} sample_recorder_cmds;

void sample_recorder_routine();

alt_u8* get_sample(alt_u8 num);

#endif /* SAMPLE_RECORDER_H_ */
