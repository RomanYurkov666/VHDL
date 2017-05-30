/*
 * ad8369.h
 *
 *  Created on: 23.11.2016
 *      Author: user
 */

#ifndef AD8369_H_
#define AD8369_H_

#define VGA_WORD_LEN 4
#define VGA_CLK_DIV 10
#define VGA_CLK_POL 0
#define VGA_CLK_PH 0

typedef enum
{
  min5db = 0x0,
  min2db = 0x1,
  plus1db = 0x2,
  plus4db = 0x3,
  plus7db = 0x4,
  plus10db = 0x5,
  plus13db = 0x6,
  plus16db = 0x7,
  plus19db = 0x8,
  plus22db = 0x9,
  plus25db = 0xA,
  plus28db = 0xB,
  plus31db = 0xC,
  plus34db = 0xD,
  plus37db = 0xE,
  plus40db = 0xF
} t_vga_gains;

void set_VGA_gain(unsigned char gain);

#endif /* AD8369_H_ */
