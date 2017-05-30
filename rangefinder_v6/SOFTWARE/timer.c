/*
 * timer.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

#include "system.h"
#include "altera_avalon_timer_regs.h"

#define CPU_FREQ 133333333
#define SYSTEM_FREQ 1000
#define TIMER_PERIOD (CPU_FREQ/SYSTEM_FREQ)

volatile int timer_context;
void* timer_context_ptr = (void*)&timer_context;
unsigned char timer_event_flag = 0;

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void sys_timer_interrupt_handler(void* context)
#else
static void sys_timer_interrupt_handler(void* context, alt_u32 id)
#endif
{
	unsigned short status = 0;
	timer_context_ptr = (volatile int*) context;
	status=IORD_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE, status&(~ALTERA_AVALON_TIMER_CONTROL_ITO_MSK));
	timer_event_flag=1;
}

void sys_timer_init()
{
	register_sys_timer_interrupt(); //registration of interrupt
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_STOP_MSK);
	IOWR_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE,0);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_ITO_MSK|ALTERA_AVALON_TIMER_CONTROL_CONT_MSK);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_0(SYS_TIMER_BASE, TIMER_PERIOD&0xFFFF);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_1(SYS_TIMER_BASE, (TIMER_PERIOD>>16)&0xFFFF);
}

void sys_timer_start()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_START_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_STOP_MSK));

}

void sys_timer_stop()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_STOP_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_START_MSK));
}

void register_sys_timer_interrupt()
{
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
alt_ic_isr_register(SYS_TIMER_IRQ_INTERRUPT_CONTROLLER_ID, SYS_TIMER_IRQ,
		sys_timer_interrupt_handler, timer_context_ptr, 0x0);
#else
  alt_irq_register(SYS_TIMER_IRQ, timer_context_ptr,
		  sys_timer_interrupt_handler);
#endif
}

unsigned char check_timer_event()
{
  return timer_event_flag;
}

void reset_timer_event_flag()
{
	timer_event_flag=0;
}

