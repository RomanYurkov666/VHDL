#include <stdio.h>
#include <io.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "timer.h"
#include "i2c.h"
#include "laser.h"
#include "sample_loader.h"
#include "accelerometer.h"
#include "leds.h"
#include "buttons.h"
#include "measurement.h"
#include "test_generator.h"
#include "tdc.h"
#include "vga.h"

void sys_init();
void mainloop();

unsigned char i = 0;

int main ()
{
   sys_init();
   while (1) mainloop();
   return 0;
}

void sys_init()
{
	//Modules
	sys_timer_init();
	sys_timer_start();
	i2c_init();
	leds_init();
	test_pulse_generator_init();
	//Devices
	accelerometer_init();
	//tdc_init();
	vga_init();
}

void mainloop()
{
	if (check_timer_event()) //system_period - 1ms
	{
		i++;
		if (i>100)
		{
			i=0;
			tdc_init();
			generate_test_pulses();
			read_tdc_result();
			//tdc_test();
		}
		reset_timer_event_flag();
		refresh_accelerometer_data();
		leds_driver();
		read_but();
	    //generate_pulse(i++);
	}
   if (buttons_status()->but_0_negedge)
   {
	   buttons_status()->but_0_negedge=0;
   }
   if (buttons_status()->but_1_negedge)
   {
	  buttons_status()->but_1_negedge=0;
      change_axis();
      make_measurement();
   }
   vga_init();
}



