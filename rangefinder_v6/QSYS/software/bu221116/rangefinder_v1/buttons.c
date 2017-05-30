
#include "global.h"
#include "buttons.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "timer.h"

#define LONG_PRESS_TIME_MS 2500
#define BUT0 (IORD_ALTERA_AVALON_PIO_DATA(BUTTONS_PORT_BASE)&BIT0)
#define BUT1 (IORD_ALTERA_AVALON_PIO_DATA(BUTTONS_PORT_BASE)&BIT1)



struct flags_info flags;
struct flags_info *f;
struct buttons_data buttons;
struct buttons_data *b;



void buttons_handler_init()
{
	f=&flags;
	b=&buttons;

    f->but_0_negedge=0;
    f->but_0_posedge=0;
    f->but_1_negedge=0;
    f->but_1_posedge=0;
    //f->sys_timer=0;

    b->but0_posedge_cnt=0;
    b->but0_negedge_cnt=0;
    b->but0_posedge_en=0;
    b->but0_negedge_en=1;

    b->but1_posedge_cnt=0;
    b->but1_negedge_cnt=0;
    b->but1_posedge_en=0;
    b->but1_negedge_en=1;
}

void read_but()
{
	unsigned int sys_time = 0;
	sys_time = read_sys_time_ms();

    if (BUT0)
      {
        b->but0_negedge_cnt=0;
        if (b->but0_posedge_en)
        {
            b->but0_posedge_cnt++;
            if (b->but0_posedge_cnt==16) {b->but0_posedge_cnt=0; f->but_0_posedge=1; b->but0_posedge_en=0; b->but0_negedge_en=1;}
        }
        b->but0_last_pressed_time=sys_time;
      }
    else
     {
       b->but0_posedge_cnt=0;
       if (b->but0_negedge_en)
        {
            b->but0_negedge_cnt++;
            if (b->but0_negedge_cnt==16) {b->but0_negedge_cnt=0; f->but_0_negedge=1; b->but0_negedge_en=0; b->but0_posedge_en=1;}
        }
       if ((sys_time-b->but0_last_pressed_time)>LONG_PRESS_TIME_MS) {f->but_0_long_pressed=1; b->but0_last_pressed_time=sys_time;}
     }

    if (BUT1)
      {
        b->but1_negedge_cnt=0;
        if (b->but1_posedge_en)
        {
            b->but1_posedge_cnt++;
            if (b->but1_posedge_cnt==16) {b->but1_posedge_cnt=0; f->but_1_posedge=1; b->but1_posedge_en=0; b->but1_negedge_en=1;}
        }
        b->but1_last_pressed_time=sys_time;
      }
    else
     {
       b->but1_posedge_cnt=0;
       if (b->but1_negedge_en)
        {
            b->but1_negedge_cnt++;
            if (b->but1_negedge_cnt==16) {b->but1_negedge_cnt=0; f->but_1_negedge=1; b->but1_negedge_en=0; b->but1_posedge_en=1;}
        }
       if ((sys_time-b->but1_last_pressed_time)>LONG_PRESS_TIME_MS) {f->but_1_long_pressed=1; b->but1_last_pressed_time=sys_time;}
     }
}

struct flags_info* buttons_status()
{
   return f;
}

