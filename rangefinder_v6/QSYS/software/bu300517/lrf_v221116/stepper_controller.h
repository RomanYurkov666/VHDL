/*
 * stepper_controller.h
 *
 *  Created on: 02.12.2016
 *      Author: user
 */

#ifndef STEPPER_CONTROLLER_H_
#define STEPPER_CONTROLLER_H_

#define CONTROL_REG_ADDR 0x0
#define POSITION_REG_ADDR 0x1
#define SPEED_REG_ADDR 0x2
#define DISTANCE_REG_ADDR 0x3

typedef enum
{
	cmd_go_forward = 0x0,
	cmd_go_back = 0x1,
	cmd_stop = 0x2,
	cmd_go_forward_on_distance = 0x3,
	cmd_go_back_on_distance = 0x4,
	cmd_read_position = 0x5,
	cmd_reset_position = 0x6
} stepper_cmds;

void start_moving(unsigned int base, unsigned char dir, unsigned int speed_div);
void stop_moving(unsigned int base);
void move_on_distance(unsigned int base, unsigned char dir, unsigned int speed_div, unsigned int distance);
unsigned int current_pos(unsigned int base);
void reset_position(unsigned int base);

#endif /* STEPPER_CONTROLLER_H_ */
