/*
 * time.h
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

#ifndef TIME_H_
#define TIME_H_

typedef struct
{
  unsigned mainloop :1;
  unsigned spi_module: 1;
  unsigned tdc :1;
} system_timer_flags;

void timers_init();
system_timer_flags* sys_timer_flags();

#endif /* TIME_H_ */
