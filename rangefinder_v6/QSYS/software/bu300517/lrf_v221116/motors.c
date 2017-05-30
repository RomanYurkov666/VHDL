/*
 * iris.c
 *
 *  Created on: 02.12.2016
 *      Author: user
 */

#include "stepper_controller.h"
#include "motors.h"
#include "system.h"
#include "pc_com.h"


void open_drive (unsigned int speed, unsigned char motor);
void close_drive (unsigned int speed, unsigned char motor);
void stop_drive(unsigned char motor);
void drive_change_pos(unsigned int position, unsigned int speed, unsigned char dir, unsigned char motor);
unsigned int drive_pos (unsigned char motor);
void reset_drive_position(unsigned char motor);

//void reset_drive_position(unsigned char motor);
void ProcCmd_Motor(t_pc_cmd* cmd);


void open_drive (unsigned int speed, unsigned char motor)
{
	if (motor==0) //iris
		start_moving(STEPPER_IRIS_BASE,1,speed);
	else
		start_moving(STEPPER_ATTEN_BASE,1,speed);
}

void close_drive (unsigned int speed, unsigned char motor)
{
	if (motor==0) //iris
		start_moving(STEPPER_IRIS_BASE,0,speed);
	else
		start_moving(STEPPER_ATTEN_BASE,0,speed);
}

void stop_drive(unsigned char motor)
{
	if (motor==0) //iris
		stop_moving(STEPPER_IRIS_BASE);
	else
		stop_moving(STEPPER_ATTEN_BASE);
}

void drive_change_pos(unsigned int position, unsigned int speed, unsigned char dir, unsigned char motor)
{
	if (motor==0)
		move_on_distance(STEPPER_IRIS_BASE,dir,speed,position);
	else
		move_on_distance(STEPPER_ATTEN_BASE,dir,speed,position);
}

unsigned int drive_pos (unsigned char motor)
{
	if (motor==0)
		return current_pos(STEPPER_IRIS_BASE);
	else
		return current_pos(STEPPER_ATTEN_BASE);
}

void reset_drive_position(unsigned char motor)
{
	if (motor==0)
		reset_position(STEPPER_IRIS_BASE);
	else
		reset_position(STEPPER_ATTEN_BASE);
}

void ProcCmd_Motor(t_pc_cmd* cmd)
{
	unsigned int speed = 0;
	unsigned int position = 0;
	unsigned char motor = (cmd->code==PCCOM_STEPPER_IRIS)?0x0:0x1;

	speed = ((unsigned int)(cmd->data[1]))|(((unsigned int)(cmd->data[2]))<<8)|(((unsigned int)(cmd->data[3]))<<16)|(((unsigned int)(cmd->data[4]))<<24);
	position = ((unsigned int)(cmd->data[5]))|(((unsigned int)(cmd->data[6]))<<8);

	switch (cmd->data[0])
	{
	case cmd_go_forward:
			{
			open_drive(speed,motor);
			} break;
	case cmd_go_back:
			{
			close_drive(speed,motor);
			} break;
	case cmd_stop:
			{
			stop_drive(motor);
			} break;
	case cmd_go_forward_on_distance:
			{
			drive_change_pos(position,speed,1,motor);
			} break;
	case cmd_go_back_on_distance:
			{
			drive_change_pos(position,speed,0,motor);
			} break;
	case cmd_read_position:
			{
				position = drive_pos(motor);
				t_pc_cmd pack;
				pack.sign = SIGN;
				pack.code = cmd->code;
				pack.dlen = 4;
				pack.data[0] = position&0xff;   //position
				pack.data[1] = (position>>8)&0xff;
				pack.data[2] = (position>>16)&0xff;
				pack.data[3] = (position>>24)&0xff;
				send_cmd2pc(&pack);
			} break;
	case cmd_reset_position:
				{
					reset_drive_position(motor);
				} break;
	}
}

