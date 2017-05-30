/* 
 * File:   buttons.h
 * Author: Igor
 *
 * Created on 9 ???? 2015 ?., 11:22
 */

#ifndef BUTTONS_H
#define	BUTTONS_H

#ifdef	__cplusplus
extern "C" {
#endif




#ifdef	__cplusplus
}
#endif

#endif	/* BUTTONS_H */

struct flags_info
{
   unsigned but_0_negedge :1;
   unsigned but_0_posedge :1;
   unsigned but_0_long_pressed :1;
   unsigned but_1_negedge :1;
   unsigned but_1_posedge :1;
   unsigned but_1_long_pressed :1;
};

struct buttons_data
{
   unsigned char but0_posedge_cnt;
   unsigned char but0_negedge_cnt;
   unsigned char but1_posedge_cnt;
   unsigned char but1_negedge_cnt;
   unsigned int but0_last_pressed_time;
   unsigned int but1_last_pressed_time;
   unsigned but0_posedge_en :1;
   unsigned but0_negedge_en :1;
   unsigned but1_posedge_en :1;
   unsigned but1_negedge_en :1;
};

void buttons_handler_init();
void read_but();
struct flags_info* buttons_status();
