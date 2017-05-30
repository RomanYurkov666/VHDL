/*
 * time.h
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#ifndef TIME_H_
#define TIME_H_

#include "alt_types.h"

#define CPU_CLK_FREQ 100000000 //133 MHz
#define SYS_TIMER_FREQ_HZ 1000
#define SYS_TIMER_TICK_PERIOD (CPU_CLK_FREQ/SYS_TIMER_FREQ_HZ)

typedef struct
{
  unsigned mainloop :1;
  unsigned spi_module: 1;
  unsigned tdc :1;
} system_timer_flags;

void timers_init();
system_timer_flags* sys_timer_flags();
alt_u32 get_sys_timer_value();
alt_u32 get_system_time();
alt_u32 simple_delay(alt_u32 value);

#endif /* TIME_H_ */
