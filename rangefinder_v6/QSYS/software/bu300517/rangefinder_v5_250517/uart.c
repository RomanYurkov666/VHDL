/*
 * uart.c
 *
 *  Created on: 22.11.2016
 *      Author: user
 */

/*
#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_pio_regs.h"
#include "uart.h"
#include "motors.h"
#include "tdc7200.h"
#include "ad8369.h"
#include "max1932.h"
#include "sample_loader.h"
#include "laser_driver.h"
#include "string.h"
#include <sys/alt_irq.h>

volatile int uart_context;
void* uart_context_ptr = (void*)&uart_context;

#define CPU_CLK_FREQ 100000000
#define UART_BAUD_RATE 115200
#define UART_DIVIDER ((CPU_CLK_FREQ/UART_BAUD_RATE) + 1)

t_uart_reciever pc_rec;
unsigned char uart_handler_buffer[RX_BUF_SIZE];

void register_uart_interrupt();
unsigned char is_buffer_full(t_uart_reciever* rec);
unsigned char is_buffer_empty(t_uart_reciever* rec);
unsigned char byte_cnt(t_uart_reciever* rec);
unsigned char read_data_in_buffer();
unsigned char msg_crc(unsigned char *ptr, unsigned char len);
void pc_command_handler(unsigned char *msg);
unsigned char new_cycle_pos(unsigned char old, unsigned char shift);
unsigned char send_byte_by_uart(unsigned char tx_byte);

unsigned char send_data2pc(unsigned char *msg, unsigned char len);
unsigned char send_cmd2pc(t_pc_cmd *cmd);

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void uart_interrupt_handler(void* context)
#else
static void uart_interrupt_handler(void* context, alt_u32 id)
#endif
{
	unsigned int status = IORD_ALTERA_AVALON_UART_STATUS(PC_UART_BASE);
	unsigned int rx_data = IORD_ALTERA_AVALON_UART_RXDATA(PC_UART_BASE); //reading and clearing interrupt flag
	if (status&ALTERA_AVALON_UART_STATUS_RRDY_MSK)
	{
		if (!is_buffer_full(&pc_rec))
		{
			pc_rec.data[pc_rec.wr_ptr] = rx_data;
			pc_rec.wr_ptr++;
			if (pc_rec.wr_ptr>(sizeof(pc_rec.data)-1)) //cycle write ptr
				pc_rec.wr_ptr=0;
		}
	}
}

void register_uart_interrupt()
{
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
alt_ic_isr_register(PC_UART_IRQ_INTERRUPT_CONTROLLER_ID, PC_UART_IRQ, uart_interrupt_handler, uart_context_ptr, 0x0);
#else
  alt_irq_register(SYS_TIMER_IRQ, sys_timer_context_ptr, sys_timer_interrupt_handler);
#endif
}

void pc_uart_init()
{
	unsigned int baud_divisor;

	register_uart_interrupt(); //register interrupt

	baud_divisor = (unsigned int)UART_DIVIDER;
	IOWR_ALTERA_AVALON_UART_DIVISOR(PC_UART_BASE, baud_divisor); //set speed
	IOWR_ALTERA_AVALON_UART_CONTROL(PC_UART_BASE, ALTERA_AVALON_UART_CONTROL_RRDY_MSK); //enable read-ready interrupt

	memset(pc_rec.data,0,sizeof(pc_rec.data));
	pc_rec.rd_ptr=0;
	pc_rec.wr_ptr=0;
	pc_rec.byte_cnt=0;
	pc_rec.buffer_full=0;

	memset(uart_handler_buffer,0,sizeof(uart_handler_buffer));
}

void pc_uart_routine()
{
	if (byte_cnt(&pc_rec) > MIN_MSG_LEN)
	{
		if (pc_rec.wr_ptr>pc_rec.rd_ptr)
			memcpy(uart_handler_buffer,pc_rec.data + pc_rec.rd_ptr,(pc_rec.wr_ptr-pc_rec.rd_ptr));
		else
			{
			unsigned char first_part = sizeof(pc_rec.data)-1-pc_rec.rd_ptr;
			memcpy(uart_handler_buffer,pc_rec.data + pc_rec.rd_ptr,first_part);
			memcpy(uart_handler_buffer + first_part,pc_rec.data,pc_rec.wr_ptr);
			}
		pc_rec.rd_ptr = read_data_in_buffer();
	}
}

unsigned char is_buffer_full(t_uart_reciever* rec)
{
	unsigned char result = 0;
  	unsigned char wrptr_next = rec->wr_ptr;
  	unsigned char limit_pos = sizeof(rec->data) - 1;
  	wrptr_next++;
  	if (wrptr_next>limit_pos)
  		wrptr_next = 0;
  	if (wrptr_next == rec->rd_ptr)
  		result = 1;
  	rec->buffer_full=result;
  	return result;
}

unsigned char is_buffer_empty(t_uart_reciever* rec)
{
	unsigned char result = 0;
  	if (rec->rd_ptr == rec->wr_ptr)
  		result = 1;
  	return result;
}

unsigned char byte_cnt(t_uart_reciever* rec)
{
	unsigned char result = 0;
	if (rec->rd_ptr > rec->wr_ptr)
		result = rec->wr_ptr + sizeof(rec->data) - rec->rd_ptr;
	else if (rec->rd_ptr < rec->wr_ptr)
		result = rec->wr_ptr - rec->rd_ptr;
	else
		result = 0;
	rec->byte_cnt=result;
	return result;
}

unsigned char read_data_in_buffer()
{
	short i = 0;
	short full_checked_pos = -1;
	short last_unchecked_sign = -1;
	unsigned char ready_bytes_cnt = 0;
	for (i=0;i<pc_rec.byte_cnt;i++)
	{
		if (SIGN == uart_handler_buffer[i])
		{
			short neccesary_byte_cnt = i+4+uart_handler_buffer[i+2];
            if (pc_rec.byte_cnt>=neccesary_byte_cnt)
            {
                unsigned char payload_len = uart_handler_buffer[i+2];
                unsigned char pack_crc = 0;
                unsigned char calculated_crc = 0xFF;
                pack_crc = uart_handler_buffer[i+3+payload_len];
                calculated_crc = msg_crc(uart_handler_buffer+i, 3+payload_len);
                if (pack_crc==calculated_crc)
                {
                    pc_command_handler(uart_handler_buffer+i);
                    full_checked_pos=i+3+payload_len;
                }
            }
            else //Недостаточно принятых байтов чтобы проверить целостность пакета
            {
                if ((last_unchecked_sign<0) || (i<last_unchecked_sign))
                    last_unchecked_sign=i;
            }
		}
	}
	if ((last_unchecked_sign<0)&&(full_checked_pos<0)) //there are now any sign
		ready_bytes_cnt=pc_rec.byte_cnt; //all bytes clears
	else if ((last_unchecked_sign>=0)&&(full_checked_pos>=0)) //there were full and part-packets
	{
		if (full_checked_pos>=last_unchecked_sign)
			ready_bytes_cnt = full_checked_pos + 1;
		else
			ready_bytes_cnt = last_unchecked_sign;
	}
	else //or
	{
		if (last_unchecked_sign>=0)
			ready_bytes_cnt = last_unchecked_sign;
		else
			ready_bytes_cnt = full_checked_pos + 1;
	}
	return new_cycle_pos(pc_rec.rd_ptr,ready_bytes_cnt);
}

unsigned char msg_crc(unsigned char *ptr, unsigned char len)
{
	unsigned char crc = 0;
	unsigned char i = 0;
	for (i=0;i<len;i++)
		crc=crc^ptr[i];
	return crc;
}

void pc_command_handler(unsigned char *msg)
{
	t_pc_cmd *cmd = (t_pc_cmd*)msg;
	switch (cmd->code)
	{
		case PCCOM_ECHO:
			send_cmd2pc(cmd);
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
			ProcCmd_PulseGen(cmd);
			break;
		case PCCOM_LASER:
			ProcCmd_Laser(cmd);
			break;
		case PCCOM_ACCELEROMETER: break;
		case PCCOM_STEPPER_IRIS:
		case PCCOM_STEPPER_ATTEN:
			ProcCmd_Motor(cmd);
			break;
		case PCCOM_AMPLIFIER: break;
		case PCCOM_APD_SOURCE:
			ProcCmd_APD(cmd);
			break;
		case PCCOM_MODE_SWITCHER:

			 break;
		case PCCOM_DEVICE:
			ProcCmd_Rangefinder(cmd);
			break;
		default: break;
	}
}

unsigned char new_cycle_pos(unsigned char old, unsigned char shift)
{
	unsigned char i = 0;
	unsigned char result = old;
	for (i=0;i<shift;i++)
	{
		result++;
		if (result>(sizeof(pc_rec.data)-1))
			result=0;
	}
	return result;
}

unsigned char send_byte_by_uart(unsigned char tx_byte)
{
    IOWR_ALTERA_AVALON_UART_TXDATA (PC_UART_BASE, tx_byte);
    while (!(IORD_ALTERA_AVALON_UART_STATUS(PC_UART_BASE)&ALTERA_AVALON_UART_STATUS_TMT_MSK));
    return 1;
}

unsigned char send_data2pc(unsigned char *msg, unsigned char len)
{
	unsigned char i = 0;
	for (i=0;i<len;i++)
		send_byte_by_uart(msg[i]);
	return 1;
}

unsigned char send_cmd2pc(t_pc_cmd *cmd)
{
	unsigned char *ptr = (unsigned char*)cmd;
	unsigned char dlen = cmd->dlen + 3; //without crc
	unsigned char crc = msg_crc(ptr,dlen);
	set_rs485_driver_dir(driver_enable);
	send_data2pc(ptr,dlen);
	send_byte_by_uart(crc);
	set_rs485_driver_dir(rec_enable);
	return 1;
}

void set_rs485_driver_dir(unsigned char dir)
{
	if (dir) //driver
		IOWR_ALTERA_AVALON_PIO_DATA(RS485_DE_BASE,0x1);
	else //reciever
		IOWR_ALTERA_AVALON_PIO_DATA(RS485_DE_BASE,0x0);
}
*/

