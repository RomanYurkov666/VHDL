/*
 * laser_driver.c
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#include "system.h"
#include "io.h"
#include "laser_driver.h"
#include "pc_com.h"

void ProcCmd_Laser(t_pc_cmd* cmd);

void generate_laser_pulse(unsigned int tpulse, unsigned int delay)
{
	//mode - 0b01 control[2:1]
	//IOWR(LASER_DRIVER_BASE,PULSE_LENGTH,tpulse);
	//IOWR(LASER_DRIVER_BASE,PULSE_DELAY,delay);
	//IOWR(LASER_DRIVER_BASE,DRIVER_CONTROL,0x3);
	generate_pulse(LASER_DRIVER_BASE,tpulse,delay,0x2); //0x3 , —брос импульса по счетчику Ћ»Ѕќ по сигналу с компаратора
}

void generate_charge_pulse(unsigned int tpulse, unsigned int delay)
{
	//mode - 0b01 control[2:1]
	//IOWR(LASER_CHARGE_BASE,PULSE_LENGTH,tpulse);
	//IOWR(LASER_CHARGE_BASE,PULSE_DELAY,delay);
	//IOWR(LASER_CHARGE_BASE,DRIVER_CONTROL,0x3);
	generate_pulse(LASER_CHARGE_BASE,tpulse,delay,0x1); //—брос импульса “ќЋ№ ќ по счетчику
}

void generate_tdc_start_pulse(unsigned int tpulse, unsigned int delay)
{
	//mode - 0b01 control[2:1]
	//IOWR(TDC_START_PULSE_GEN_BASE,PULSE_LENGTH,tpulse);
	//IOWR(TDC_START_PULSE_GEN_BASE,PULSE_DELAY,delay);
	//IOWR(TDC_START_PULSE_GEN_BASE,DRIVER_CONTROL,0x3);
	generate_pulse(TDC_START_PULSE_GEN_BASE,tpulse,delay,0x1); //—брос импульса “ќЋ№ ќ по счетчику
}

void generate_pulse(unsigned int base, unsigned int tpulse, unsigned int delay, unsigned char mode)
{
	unsigned int buf = 0;
	IOWR(base,PULSE_LENGTH,tpulse);
	IOWR(base,PULSE_DELAY,delay);
	buf = mode&0x3;
	buf = (buf << 1)|0x1;
	IOWR(base,DRIVER_CONTROL,buf);
}

void ProcCmd_Laser(t_pc_cmd* cmd)
{
	unsigned short len = 0;
	unsigned short delay = 0;
	len = cmd->data[1];
	len = len<<8;
	len|= cmd->data[0];
	delay = cmd->data[3];
	delay = len<<8;
	delay|= cmd->data[2];
	generate_laser_pulse(len,delay);
}
