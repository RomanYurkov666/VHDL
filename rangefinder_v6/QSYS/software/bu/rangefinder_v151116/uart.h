/*
 * uart.h
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

int send2pc(unsigned char *msg, unsigned short len);
int send2pc_cmdpc(CmdPC *cmd);
void read_pc_cmds();
void set_rs485driver_dir(unsigned char dir);
