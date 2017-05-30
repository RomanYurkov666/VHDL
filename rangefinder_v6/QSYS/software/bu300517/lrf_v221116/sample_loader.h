/*
 * sample_loader.h
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#ifndef SAMPLE_LOADER_H_
#define SAMPLE_LOADER_H_

#define CONTROL_REG    0x0
#define PULSE_CNT_REG  0x1
#define ABS_CNT_REG    0x2
#define START_RAM      0x3
#define STOP0_RAM      0x4
#define STOP1_RAM      0x5
#define STOP2_RAM      0x6
#define STOP3_RAM      0x7
#define STOP4_RAM      0x8

typedef struct
{
	unsigned short pulse_abs_coord;
	unsigned char sample_size;
	unsigned char ram_ptr;
	unsigned buffer_full :1;
	unsigned stop_detected :1;
} sample_buffer_data;

typedef struct
{
	unsigned short abs_position;
	unsigned char amplitude;
	unsigned char width;
	unsigned char detected;
	unsigned char sample[256];
} pulse_data;

typedef struct
{
	unsigned char pulse_counter;
	unsigned short distance;
	pulse_data pulse[6];
} echo_signal_data;

typedef enum
{
  start_sample = 0x0,
  stop_sample = 0x1,
  read_sample = 0x2
} sample_loader_cmds;

alt_u8* get_sample(alt_u8 num);

#endif /* SAMPLE_LOADER_H_ */
