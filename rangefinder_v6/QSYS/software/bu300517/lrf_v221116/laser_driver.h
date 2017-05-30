/*
 * laser_driver.h
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#ifndef LASER_DRIVER_H_
#define LASER_DRIVER_H_

#define DRIVER_CONTROL    0x0
#define DRIVER_STATUS     0x1
#define PULSE_LENGTH      0x2
#define PULSE_DELAY       0x3
#define PULSE_BACK_DELAY  0x4

void generate_laser_pulse(unsigned int tpulse, unsigned int delay);
void generate_charge_pulse(unsigned int tpulse, unsigned int delay);
void generate_tdc_start_pulse(unsigned int tpulse, unsigned int delay);
void generate_pulse(unsigned int base, unsigned int tpulse, unsigned int delay, unsigned char mode);


#endif /* LASER_DRIVER_H_ */
