/*
 * rangefinder.h
 *
 *  Created on: 25.01.2017
 *      Author: Igor
 */

#ifndef RANGEFINDER_H_
#define RANGEFINDER_H_

#define RMS_FILTER_SIZE 9

typedef enum
{
    dev_start_meas = 0x0,
    dev_sys_mux_switch_test = 0x1,
    dev_sys_mux_switch_normal = 0x2
} device_commands;

void calibrate_photodetector();
void photodetector_calibrating_routine();

#endif /* RANGEFINDER_H_ */
