/*
 * timer.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

#include "system.h"
#include "altera_avalon_timer_regs.h"
#include "global.h"
#include "io.h"

#define CPU_FREQ 133333333
#define SYSTEM_FREQ 1000 //1ms
#define SERVICE_FREQ 10000 //100 usec
#define TIMER_PERIOD (CPU_FREQ/SYSTEM_FREQ)
#define SERVICE_TIMER_PERIOD (CPU_FREQ/SERVICE_FREQ)

volatile int timer_context;
void* timer_context_ptr = (void*)&timer_context;
unsigned char timer_event_flag = 0;
unsigned int sys_abs_time_ms = 0;
volatile int service_timer_context;
void* service_timer_context_ptr = (void*)&service_timer_context;
unsigned char service_timer_event_flag = 0;
unsigned int service_timer_ticks_cnt = 0;

unsigned short neccesary_tickes_cnt = 0;
unsigned char rs485_switch_request_flag = 0;

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
	sys_abs_time_ms++;
}

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void service_timer_interrupt_handler(void* context)
#else
static void service_timer_interrupt_handler(void* context, alt_u32 id)
#endif
{
	unsigned short status = 0;
	service_timer_context_ptr = (volatile int*) context;
	status=IORD_ALTERA_AVALON_TIMER_STATUS(SERVICE_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_STATUS(SERVICE_TIMER_BASE, status&(~ALTERA_AVALON_TIMER_CONTROL_ITO_MSK));
	service_timer_event_flag=1;
	service_timer_ticks_cnt++;
}

void sys_timer_init()
{
	register_sys_timer_interrupt(); //registration of interrupt
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_STOP_MSK);
	IOWR_ALTERA_AVALON_TIMER_STATUS(SYS_TIMER_BASE,0);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_ITO_MSK|ALTERA_AVALON_TIMER_CONTROL_CONT_MSK);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_0(SYS_TIMER_BASE, TIMER_PERIOD&0xFFFF);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_1(SYS_TIMER_BASE, (TIMER_PERIOD>>16)&0xFFFF);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_STOP_MSK);
	IOWR_ALTERA_AVALON_TIMER_STATUS(SERVICE_TIMER_BASE,0);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_ITO_MSK|ALTERA_AVALON_TIMER_CONTROL_CONT_MSK);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_0(SERVICE_TIMER_BASE, SERVICE_TIMER_PERIOD&0xFFFF);
	IOWR_ALTERA_AVALON_TIMER_PERIOD_1(SERVICE_TIMER_BASE, (SERVICE_TIMER_PERIOD>>16)&0xFFFF);
}

void sys_timer_start()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_START_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_STOP_MSK));
}

void service_timer_start()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_START_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_STOP_MSK));
}

void sys_timer_stop()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SYS_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_STOP_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_START_MSK));
}

void service_timer_stop()
{
	unsigned short buf = 0;
	buf=IORD_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SERVICE_TIMER_BASE, (buf|ALTERA_AVALON_TIMER_CONTROL_STOP_MSK)&(~ALTERA_AVALON_TIMER_CONTROL_START_MSK));
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
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
alt_ic_isr_register(SERVICE_TIMER_IRQ_INTERRUPT_CONTROLLER_ID, SERVICE_TIMER_IRQ,
		service_timer_interrupt_handler, service_timer_context_ptr, 0x0);
#else
  alt_irq_register(SERVICE_TIMER_IRQ, service_timer_context_ptr,
		  service_timer_interrupt_handler);
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

unsigned int read_sys_time_ms()
{
   return sys_abs_time_ms;
}

void request_for_rs485_driver_switch(unsigned char ticks)
{
	neccesary_tickes_cnt = ticks;
	service_timer_ticks_cnt = 0;
	rs485_switch_request_flag = 1;
}

void service_timer_routine()
{
	if (rs485_switch_request_flag)
	{
		if (service_timer_ticks_cnt >= neccesary_tickes_cnt)
		{
			set_rs485driver_dir(de_receiver);
			rs485_switch_request_flag = 0;
		}
	}
}
