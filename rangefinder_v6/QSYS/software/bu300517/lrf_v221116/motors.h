/*
 * iris.h
 *
 *  Created on: 02.12.2016
 *      Author: user
 */

#ifndef IRIS_H_
#define IRIS_H_

#include "pc_com.h"

void open_drive (unsigned int speed, unsigned char motor);
void close_drive (unsigned int speed, unsigned char motor);
void stop_drive(unsigned char motor);
void drive_change_pos(unsigned int position, unsigned int speed, unsigned char dir, unsigned char motor);
unsigned int drive_pos (unsigned char motor);
void reset_drive_position(unsigned char motor);
void ProcCmd_Motor(t_pc_cmd* cmd);

#endif /* IRIS_H_ */
