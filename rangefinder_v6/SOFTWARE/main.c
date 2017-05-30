#include <stdio.h>
#include <io.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "timer.h"
#include "i2c.h"
#include "laser.h"
#include "sample_loader.h"


void sys_init();
void mainloop();

int main ()
{
   sys_init();
   while (1) mainloop();
   return 0;
}

void sys_init()
{
	sys_timer_init();
	sys_timer_start();
	i2c_init();
	start_recording(10);
}

void mainloop()
{
	if (check_timer_event()) //system_period - 1ms
	{
		unsigned char id = 0;
		reset_timer_event_flag();
		//write_command (0x55, 0xF0);
		id = read_command(0);
		generate_pulse(10);  //10*5ns = 50ns
		IOWR_ALTERA_AVALON_PIO_DATA(LEDS_PORT_BASE, ~IORD_ALTERA_AVALON_PIO_DATA(LEDS_PORT_BASE));
	}
}



