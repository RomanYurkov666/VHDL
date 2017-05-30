/*
 * pulse_generator.h
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#ifndef PULSE_GENERATOR_H_
#define PULSE_GENERATOR_H_

typedef struct
{
  unsigned short delay;
  unsigned short len;
  unsigned char enable;
} test_pulse_parameter;

void init_pulse_generator();
void generate_test_pulses();


#endif /* PULSE_GENERATOR_H_ */
