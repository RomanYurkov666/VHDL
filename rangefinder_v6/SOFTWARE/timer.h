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
