/*
 * measurement.c
 *
 *  Created on: 02.06.2016
 *      Author: user
 */


#include "laser.h"
#include "sample_loader.h"
#include "timer.h"

#define PULSE_WIDTH_NS 20
#define WRITING_DELAY_NS 20

#define LASER_DRIVER_REF_CLK 200000000
#define SAMPLE_LOADER_REF_CLK 200000000
#define LASER_PULSE_COUNTS  (PULSE_WIDTH_NS/(1000000000/LASER_DRIVER_REF_CLK))
#define WRITING_DELAY_COUNTS (WRITING_DELAY_NS/(1000000000/SAMPLE_LOADER_REF_CLK))

//20km = (2e4)/(2,998e8)=6,671e-5s
//6,671e-5s = 66,71usec
//66,71usec/5ns = 13342 counts
void delay(unsigned int time);

void make_measurement()
{
	unsigned int start_time=read_sys_time_ms();
	unsigned char wait = 1;
	reset_ram_buffers(); //reset buffers and prepair for measurement
	start_recording(WRITING_DELAY_COUNTS); //start signal recording
	generate_pulse(LASER_PULSE_COUNTS); //generate start pulse
	delay(100);
	generate_pulse(LASER_PULSE_COUNTS); //generate stop pulse
	delay(500);
	generate_pulse(LASER_PULSE_COUNTS); //generate stop pulse
    while (wait)
    {
    	if (read_abs_counter()>13342)
    		wait=0;
    	else if (read_sys_time_ms()>(start_time+2))
    		wait=0;
    }
    refresh_meas_data();
}

void delay(unsigned int time)
{
	unsigned int i = 0;
	for (i=0;i<time;i++) {}
}

