/*
 * global.h
 *
 *  Created on: 20.05.2016
 *      Author: user
 */

#ifndef GLOBAL_H_
#define GLOBAL_H_

#define BIT0  0x1
#define BIT1  0x2
#define BIT2  0x4
#define BIT3  0x8
#define BIT4  0x10
#define BIT5  0x20
#define BIT6  0x40
#define BIT7  0x80
#define BIT8  0x100
#define BIT9  0x200
#define BIT10 0x400
#define BIT11 0x800
#define BIT12 0x1000
#define BIT13 0x2000
#define BIT14 0x4000
#define BIT15 0x8000
#define BIT16 0x10000
#define BIT17 0x20000
#define BIT18 0x40000
#define BIT19 0x80000
#define BIT20 0x100000
#define BIT21 0x200000
#define BIT22 0x400000
#define BIT23 0x800000
#define BIT24 0x1000000
#define BIT25 0x2000000
#define BIT26 0x4000000
#define BIT27 0x8000000
#define BIT28 0x10000000
#define BIT29 0x20000000
#define BIT30 0x40000000
#define BIT31 0x80000000

#define RX_BUFFER_SIZE 64
#define TX_BUFFER_SIZE 32
#define MESSAGE_BUFFER_SIZE 16

#define PAYLOAD_LEN_MAX 255

typedef struct
{
   unsigned char buffer [RX_BUFFER_SIZE];
   unsigned char byte_cnt;
   unsigned int  msg_buf[MESSAGE_BUFFER_SIZE];
   unsigned char msg_cnt;
}  uart_reciever;

typedef struct
{
	unsigned char buffer [TX_BUFFER_SIZE];
	unsigned char size;
} uart_transmitter;

typedef struct __attribute__((__packed__)) {
    unsigned char sign;
    unsigned char code;
    unsigned char dlen;
    unsigned char data[PAYLOAD_LEN_MAX];
} CmdPC;

typedef enum
{
	de_receiver = 0x0,
	de_transmitter = 0x1
} de485_states;

typedef enum
{
  PCCOM_ECHO 			= 0x0,
  PCCOM_VGA  			= 0x1,
  PCCOM_TDC 			= 0x2,
  PCCOM_SAMPLE_LOADER	= 0x3,
  PCCOM_TEST_GENERATOR  = 0x4,
  PCCOM_LASER			= 0x5,
  PCCOM_ACCELEROMETER	= 0x6,
  PCCOM_STEPPER_IRIS	= 0x7,
  PCCOM_STEPPER_ATTEN	= 0x8,
  PCCOM_AMPLIFIER		= 0x9,
  PCCOM_APD_SOURCE		= 0xA,
  PCCOM_MODE_SWITCHER   = 0xB
} t_pc_cmd_codes;


#endif /* GLOBAL_H_ */
