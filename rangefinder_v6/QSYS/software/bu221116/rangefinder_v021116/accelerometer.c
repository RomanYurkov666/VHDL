/*
 * accelerometer.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

#define ACCEL_DEVID_REG        0x00
#define ACCEL_POW_CTL_REG      0x2D
#define ACCEL_DATA_FORMAT_REG  0x31
#define ACCEL_FIFO_CTL_REG     0x38
#define ACCEL_DATAX0_REG       0x32
#define ACCEL_DATAX1_REG       0x33
#define ACCEL_DATAY0_REG       0x34
#define ACCEL_DATAY1_REG       0x35
#define ACCEL_DATAZ0_REG       0x36
#define ACCEL_DATAZ1_REG       0x37



#include "i2c.h"


unsigned short DATAX = 0;
unsigned short DATAY = 0;
unsigned short DATAZ = 0;
int x_angle = 0;
int y_angle = 0;
int z_angle = 0;


void accelerometer_init()
{
	write_command (ACCEL_POW_CTL_REG, 0x08);     //power control - measure
	write_command (ACCEL_DATA_FORMAT_REG, 0x08); //data format - full resolution
	write_command (ACCEL_FIFO_CTL_REG, 0x00); // fifo - bypassed
}

void refresh_accelerometer_data()
{
	unsigned char buf = 0;

	buf=read_command(ACCEL_DATAX0_REG);
	DATAX=buf;
	buf=read_command(ACCEL_DATAX1_REG);
	DATAX|=(buf<<8)&0xff00;
	buf=read_command(ACCEL_DATAY0_REG);
	DATAY=buf;
	buf=read_command(ACCEL_DATAY1_REG);
	DATAY|=(buf<<8)&0xff00;
	buf=read_command(ACCEL_DATAZ0_REG);
	DATAZ=buf;
	buf=read_command(ACCEL_DATAZ1_REG);
	DATAZ|=(buf<<8)&0xff00;

	x_angle=DATAX&0x1FFF;
	y_angle=DATAY&0x1FFF;
	z_angle=DATAZ&0x1FFF;
}

unsigned short get_x_coord()
{
  return x_angle;
}

unsigned short get_y_coord()
{
  return y_angle;
}

unsigned short get_z_coord()
{
  return z_angle;
}
