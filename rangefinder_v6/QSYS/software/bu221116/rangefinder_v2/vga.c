/*
 * vga.c
 *
 *  Created on: 29.10.2016
 *      Author: Igor
 */
#include "system.h"
#include "io.h"

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

void write_data2vga(unsigned char data);

void vga_init()
{
	write_data2vga(plus16db);
}

void write_data2vga(unsigned char data)
{
   unsigned int buf = 0;

   unsigned int tx_data;
   unsigned char clk_div;
   unsigned char clk_pol;
   unsigned char clk_phase;
   unsigned char datalen;

   unsigned int set = 0;

   clk_div = 13;
   clk_pol = 0;
   clk_phase = 0;
   datalen = 4;

   tx_data = data;
   tx_data = tx_data <<28;

   if (clk_pol) set|=0x2;
   if (clk_phase) set|=0x4;
   set=datalen<<3;
   set|=buf;
   buf=clk_div<<11;
   set|=buf;

#define SPI_CONTROLLER_VGA_BASE 0x9740

   IOWR(SPI_CONTROLLER_VGA_BASE,0,set);

   IOWR(SPI_CONTROLLER_VGA_BASE,2,tx_data);

   set|=0x1;
   IOWR(SPI_CONTROLLER_VGA_BASE,0,set);
}

