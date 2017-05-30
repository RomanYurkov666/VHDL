/*
 * tdc7200.h
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#ifndef TDC7200_H_
#define TDC7200_H_

#define TDC_LONG_WORD_LEN 32
#define TDC_SHORT_WORD_LEN 16
#define TDC_CLK_DIV 10
#define TDC_CLK_POL 0
#define TDC_CLK_PH 0

#define CONFIG1_ADDR 		0x0
#define CONFIG2_ADDR 		0x1
#define INT_STATUS 			0x2
#define INT_MASK			0x3
#define COARSE_CNTR_OVF_H	0x4
#define COARSE_CNTR_OVF_L	0x5
#define CLOCK_CNTR_OVF_H	0x6
#define CLOCK_CNTR_OVF_L	0x7
#define CLOCK_CNTR_STOP_MASK_H 0x8
#define CLOCK_CNTR_STOP_MASK_L 0x9
#define TIME1				0x10
#define CLOCK_COUNT1		0x11
#define TIME2				0x12
#define CLOCK_COUNT2		0x13
#define TIME3				0x14
#define CLOCK_COUNT3		0x15
#define TIME4				0x16
#define CLOCK_COUNT4		0x17
#define TIME5				0x18
#define CLOCK_COUNT5		0x19
#define TIME6				0x1A
#define CALIBRATION1		0x1B
#define CALIBRATION2		0x1C

typedef enum
{
	write_reg = 0x0,
	read_reg = 0x1,
	reset_chip = 0x2,
	start_measure = 0x3,
	stop_measure = 0x4,
	init_chip = 0x5
} tdc_local_cmds;

typedef enum
{
	disable = 0x0,
	enable = 0x1
} tdc_enable_pin_states;

void Init_TDC7200(void);
void set_tdc_chip_enable(unsigned char nReset);
void tdc_start_measure();
void tdc_stop_measure();


#endif /* TDC7200_H_ */
