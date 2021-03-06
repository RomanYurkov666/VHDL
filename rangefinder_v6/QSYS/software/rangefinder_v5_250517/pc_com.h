/*
 * pc_com.h
 *
 *  Created on: 25.05.2017
 *      Author: user
 */

#ifndef PC_COM_H_
#define PC_COM_H_

#define CPU_CLK_FREQ 100000000
#define UART_BAUD_RATE 115200
#define UART_DIVIDER ((CPU_CLK_FREQ/UART_BAUD_RATE) + 1)

#define UART_RX_BUF_SIZE 128

#define PC_MIN_MSG_SIZE 4
#define PAYLOAD_LEN_MAX 32

#define BUS_BUSY_DELAY 20000

#define SIGN 0x5B

typedef struct __attribute__((__packed__)) {
    unsigned char sign;
    unsigned char code;
    unsigned char dlen;
    unsigned char data[PAYLOAD_LEN_MAX];
} t_pc_cmd;

typedef enum
{
	reciever_mode = 0x0,
	transmitter_mode = 0x1
} t_driver_states;

typedef enum
{
	rec_enable = 0x0,
	driver_enable = 0x1
} rs485_driver_states;

typedef struct
{
	unsigned int base;
	unsigned int irq;
	unsigned int interr_id;
	unsigned int speed_divider;
} t_uart_module_config;

typedef struct
{
	t_uart_module_config controller;
	unsigned char bus_is_busy;
	unsigned int last_byte_timestamp;
	unsigned int last_byte_tick_stamp;
	unsigned char rx_buf_full;
	unsigned char error;
	unsigned char driver_direction;
	unsigned short rx_byte_cnt;
	unsigned char rx_buf[UART_RX_BUF_SIZE];
} t_rs485_config;

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
  PCCOM_MODE_SWITCHER   = 0xB,
  PCCOM_DEVICE          = 0xDE
} t_pc_cmd_codes;

void com_init();
void com_routine();
unsigned char send_cmd2pc(t_pc_cmd *cmd);

#endif /* PC_COM_H_ */
