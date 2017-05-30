/*
 * timer.h
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

void sys_timer_init();
void sys_timer_start();
void sys_timer_stop();
unsigned char check_timer_event();
void reset_timer_event_flag();
unsigned int read_sys_time_ms();
void request_for_rs485_driver_switch(unsigned char ticks);
void service_timer_routine();
void delay_us_by_timer(unsigned short value_us);