/*
 * File:   i2c.h
 * Author: Igor
 *
 * Created on 28 ??? 2015 ?., 12:50
 */


void i2c_init();
unsigned char read_ack();
unsigned char write_ack(unsigned char ack);
void write_command (unsigned char reg_addr, unsigned char data);
void write_command_multiple (unsigned char reg_addr, unsigned char *data, unsigned char size);
unsigned char read_command (unsigned char reg_addr);
