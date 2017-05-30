/*
 * main.c
 *
 *  Created on: 22.11.2016
 *      Author: user
 */
#include "time.h"
#include "pc_com.h"
#include "ad8369.h"
#include "pulse_generator.h"
#include "tdc7200.h"
#include "sample_recorder.h"

void sys_init();
void mainloop();

void sys_init()
{
	timers_init();
	com_init();

	init_sample_recorder();
	set_VGA_gain(plus1db);
	init_pulse_generator();
	Init_TDC7200();
}

void mainloop()
{
	com_routine();
	if (sys_timer_flags()->mainloop)
	{
		sys_timer_flags()->mainloop = 0;
		photodetector_calibrating_routine();
		sample_recorder_routine();
	}
}

int main ()
{
	sys_init();
	while (1)
		mainloop();
	return 1;
}
