/*
 * uart.c
 *
 *  Created on: 20.05.2016
 *      Author: user
 */
#include "global.h"
#include "system.h"
#include "uart.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_pio_regs.h"
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "timer.h"

#define CPU_FREQ     133333333
#define PC_UART_SPEED   115200
#define PC_UART_DIVIDER ((CPU_FREQ/PC_UART_SPEED)+1)

#define PC_MIN_MSG_SIZE 4
#define PC_START_SIGN 0x5B


FILE* pc_uart_file;
uart_reciever pc_uart_receiver;
uart_reciever *rec_pc = &pc_uart_receiver;
uart_transmitter pc_uart_transmitter;
uart_transmitter *trans_pc = &pc_uart_transmitter;

void pc_cmd_handler(unsigned char *msg);
unsigned char pc_crc_calc(unsigned char *msg, unsigned short size);
char integrity_check (unsigned char *msg);
void check_buffer_pc();
int send_uart(unsigned char byte, unsigned long base);
int uart_direct_transmission(unsigned char *byte, int n, unsigned long base);

void uart_init()
{
	pc_uart_file=open("/dev/pc_uart",O_NONBLOCK | O_RDWR);
	set_rs485driver_dir(de_receiver);
}

int send2pc(unsigned char *msg, unsigned short len)
{

	set_rs485driver_dir(de_transmitter);
    write(pc_uart_file,msg,len);
    request_for_rs485_driver_switch(len); //1tick - 100usec ~1byte
    return 1;
}

int send2pc_cmdpc(CmdPC *cmd)
{
	unsigned char *message = (unsigned char *)cmd;
	unsigned short full_len = cmd->dlen;
	full_len=full_len+4;
	cmd->data[cmd->dlen]=pc_crc_calc(message,cmd->dlen+3);
	set_rs485driver_dir(de_transmitter);
    //write(pc_uart_file,message,full_len);
	uart_direct_transmission_cmd(cmd);
    //request_for_rs485_driver_switch(cmd->dlen+4); //1tick - 100usec ~1byte
    return 1;
}

void read_pc_cmds()
{
	short new_data_size = 0;

	new_data_size=read(pc_uart_file,rec_pc->buffer+rec_pc->byte_cnt,sizeof(rec_pc->buffer));
    if (new_data_size>0) rec_pc->byte_cnt+=new_data_size;
    check_buffer_pc();
}

void check_buffer_pc()
{
	unsigned char i = 0;
	short last_start = -1;
	int last_msg_len = -1;
	short last_unchecked_sign = -1;
	short full_checked_pos  = -1;

    if (rec_pc->byte_cnt>(PC_MIN_MSG_SIZE-1)) //handler of tv channel
    {
      for (i=0;i<rec_pc->byte_cnt;i++)
      {
    	  if (rec_pc->buffer[i]==PC_START_SIGN)
    		  {
        	  	  char length = -1;
    		  	  short neccesary_byte_cnt = i+4+rec_pc->buffer[i+2];

				  if (rec_pc->byte_cnt>=neccesary_byte_cnt)
				  {
	    		  	  last_start=i; //Запоминаем индекс последней стартовой сигнатуры
	    		  	  length=integrity_check(rec_pc->buffer+i); //Проверяем есть ли целое сообщение
	    	          if (length>0) //Если есть
	    	          {
	    	        	  pc_cmd_handler(rec_pc->buffer+i); //Передаем в обработчик
	    	        	  i+=(length-1);//cycle increment //Пропускаем следующие байты обработанного сообщения
	    	        	  last_msg_len=length; //Запоминаем его длину
	    	        	  full_checked_pos = i + 3 + rec_pc->buffer[i+2]; //место последней проверенной crc
	    	          }
				  }
				  else //Недостаточно принятых байтов чтобы проверить целостность пакета
				  {
	                    if ((last_unchecked_sign<0) || (i<last_unchecked_sign))
	                        last_unchecked_sign=i;
				  }

    		  }

      }

      if ((full_checked_pos>=last_unchecked_sign) && (full_checked_pos>=0)) //выкидываем все байты с 0 до байта с позицией full_checked_pos включительно
    	  {
    		  unsigned char useful_payload = rec_pc->byte_cnt - full_checked_pos - 1;
    		  unsigned char i = 0;
    		  for (i=0;i<useful_payload;i++)
    			  rec_pc->buffer[i]=rec_pc->buffer[i+full_checked_pos+1];
    		  rec_pc->byte_cnt=useful_payload;
    	  }
	  else if (last_unchecked_sign>=0) //выкидываем все байты с 0 до байта с пощицией last_unchecked_sign НЕ включительно
	  	  {
		  unsigned char useful_payload = rec_pc->byte_cnt - last_unchecked_sign;
		  unsigned char i = 0;
		  for (i=0;i<useful_payload;i++)
			  rec_pc->buffer[i]=rec_pc->buffer[i+last_unchecked_sign];
		  rec_pc->byte_cnt=useful_payload;
	  	  }
	  else
	  	  {
		  rec_pc->byte_cnt=0;
	  	  }
    }
}

char integrity_check (unsigned char *msg)
{
   char msg_length = -1;
   unsigned char crc = 0;
   crc=pc_crc_calc(msg,3+msg[2]);
   if (crc==msg[3+msg[2]])
	   msg_length=4+msg[2];
   return msg_length;
}

unsigned char pc_crc_calc(unsigned char *msg, unsigned short size)
{
  unsigned char crc = 0;
  unsigned char i = 0;
  for (i=0;i<size;i++) crc=crc^msg[i];
  return crc;
}

void pc_cmd_handler(unsigned char *msg)
{
	CmdPC *cmd;
	cmd = (CmdPC*)msg;
	switch (cmd->code)
	{
		case PCCOM_ECHO:
			send2pc_cmdpc(cmd);
			break;
		case PCCOM_VGA:
			ProcCmd_VGA(cmd);
			break;
		case PCCOM_TDC:
			ProcCmd_TDC(cmd);
			break;
		case PCCOM_SAMPLE_LOADER:
			ProcCmd_SampleLoader(cmd);
			break;
		case PCCOM_TEST_GENERATOR:
			ProcCmd_Test_Gen (cmd);
			break;
		case PCCOM_LASER: break;
		case PCCOM_ACCELEROMETER: break;
		case PCCOM_STEPPER_IRIS: break;
		case PCCOM_STEPPER_ATTEN: break;
		case PCCOM_AMPLIFIER: break;
		case PCCOM_APD_SOURCE: break;
		case PCCOM_MODE_SWITCHER:

			 break;
		default: break;
	}
}

void set_rs485driver_dir(unsigned char dir)
{
	IOWR_ALTERA_AVALON_PIO_DATA(RS485_DE_BASE,dir);
}

int send_uart(unsigned char byte, unsigned long base)
{
    IOWR_ALTERA_AVALON_UART_TXDATA (base, byte);
    while (!(IORD_ALTERA_AVALON_UART_STATUS(base)&0x20));
    return 1;
}

int uart_direct_transmission(unsigned char *byte, int n, unsigned long base)
{
	int i;
	for(i=0;i<n;i++)
		send_uart(byte[i],base);
	return n;
}

int uart_direct_transmission_cmd(CmdPC *cmd)
{
	int i;
	unsigned char *msgptr = (unsigned char *)cmd;
	unsigned short dlen = cmd->dlen+3; //Without crc!!!
	unsigned char crc = pc_crc_calc(msgptr,dlen);
	set_rs485driver_dir(de_transmitter);
	for(i=0;i<dlen;i++)
		send_uart(msgptr[i],PC_UART_BASE);
	send_uart(crc,PC_UART_BASE); //last byte
	set_rs485driver_dir(de_receiver);
	return dlen;
}
