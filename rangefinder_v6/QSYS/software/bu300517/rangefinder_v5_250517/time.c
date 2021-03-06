/*
 * time.c
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#include "system.h"
#include "altera_avalon_timer_regs.h"
#include "time.h"
#include <sys/alt_irq.h>
#include "alt_types.h"
#include "sys/alt_alarm.h"
#include "stddef.h"
#include "string.h"

#define ALTERA_HANDLER



#ifdef ALTERA_HANDLER
	alt_alarm ts;
#else

#endif

volatile int sys_timer_context;
void* sys_timer_context_ptr = (void*)&sys_timer_context;

unsigned int sys_abs_time_ms = 0;

system_timer_flags tflags;
system_timer_flags *time_flags = &tflags;

alt_u32 G_system_time = 0;


#ifdef ALTERA_HANDLER
alt_u32 alarm_handler(void* context)
{
	time_flags->mainloop=1;
	time_flags->spi_module=1;
	time_flags->tdc=1;
	G_system_time++;
	return 1;
}
#else
	#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
	static void sys_timer_interrupt_handler(void* context)
	#else
	static void sys_timer_interrupt_handler(void* context, alt_u32 id)
	#endif
	{
		unsigned short status = 0;
		sys_timer_context_ptr = (volatile int*) context;
		status=IORD_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE);
		IOWR_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE, status&(~ALTERA_AVALON_TIMER_CONTROL_ITO_MSK));
		time_flags->mainloop=1;
		time_flags->spi_module=1;
		time_flags->tdc=1;
		sys_abs_time_ms++;
	}
#endif

void register_sys_timer_interrupt()
{
#ifdef ALTERA_HANDLER
	alt_alarm_start(&ts, 1, alarm_handler, NULL);
#else
	alt_ic_irq_disable(SYS_TIMER_IRQ_INTERRUPT_CONTROLLER_ID,SYS_TIMER_IRQ);
	#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
	alt_ic_isr_register(SYS_TIMER_IRQ_INTERRUPT_CONTROLLER_ID, SYS_TIMER_IRQ, sys_timer_interrupt_handler, sys_timer_context_ptr, 0x0);
	#else
	  alt_irq_register(SYS_TIMER_IRQ, sys_timer_context_ptr, sys_timer_interrupt_handler);
	#endif
	alt_ic_irq_enable(SYS_TIMER_IRQ_INTERRUPT_CONTROLLER_ID,SYS_TIMER_IRQ);
#endif
}

void timers_init()
{
#ifdef ALTERA_HANDLER
	register_sys_timer_interrupt();
#else
	unsigned int ticks = (unsigned int)SYS_TIMER_TICK_PERIOD;
   	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE,ALTERA_AVALON_TIMER_CONTROL_STOP_MSK);
	register_sys_timer_interrupt();
	IOWR_ALTERA_AVALON_TIMER_PERIODL(SYS_TIMER_BASE,ticks);
	IOWR_ALTERA_AVALON_TIMER_PERIODH(SYS_TIMER_BASE,ticks>>16);
   	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE,ALTERA_AVALON_TIMER_CONTROL_START_MSK | ALTERA_AVALON_TIMER_CONTROL_CONT_MSK);
#endif
	time_flags->mainloop=0;
	time_flags->spi_module=0;
	time_flags->tdc=0;
}

 system_timer_flags* sys_timer_flags()
{
  return time_flags;
}

alt_u32 get_sys_timer_value()
{
	alt_u32 cur_timer_value =  IORD_ALTERA_AVALON_TIMER_SNAPH(SYS_TIMER_BASE);
	cur_timer_value = cur_timer_value << 16;
	cur_timer_value|= IORD_ALTERA_AVALON_TIMER_SNAPL(SYS_TIMER_BASE);
	return cur_timer_value;
}

alt_u32 get_system_time()
{
	return G_system_time;
}

alt_u32 simple_delay(alt_u32 value)
{
	alt_u32 i = 0;
	alt_u32 b = 0;
	for (i=0;i<value;i++)
	{
		b++;
	}
	return b;
}


