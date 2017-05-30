

#include "system.h"
#include "global.h"
#include "altera_avalon_pio_regs.h"

#define SDA_READ_MODE     IOWR_ALTERA_AVALON_PIO_DIRECTION(I2C_PORT_BASE, BIT0)
#define SDA_WRITE_MODE    IOWR_ALTERA_AVALON_PIO_DIRECTION(I2C_PORT_BASE, BIT0|BIT1)
#define SCL_SET           IOWR_ALTERA_AVALON_PIO_SET_BITS(I2C_PORT_BASE, BIT0)
#define SCL_RESET         IOWR_ALTERA_AVALON_PIO_CLEAR_BITS(I2C_PORT_BASE, BIT0)
#define SDA_SET           SDA_READ_MODE//IOWR_ALTERA_AVALON_PIO_SET_BITS(I2C_PORT_BASE, BIT1)
#define SDA_RESET         SDA_WRITE_MODE//IOWR_ALTERA_AVALON_PIO_CLEAR_BITS(I2C_PORT_BASE, BIT1)
#define SDA               ((IORD_ALTERA_AVALON_PIO_DATA(I2C_PORT_BASE)&BIT1)?1:0)

#define I2C_ACCEL_ADDR 0x1D
#define I2C_ACCEL_ADDR_WR 0x3A //writing
#define I2C_ACCEL_ADDR_RD 0x3B //reading

#define I2C_SPEED 12

void i2c_start();
void i2c_stop();
void i2c_send_bit(unsigned char send_bit);
unsigned char i2c_read_bit();
unsigned char i2c_send_byte(unsigned char send_byte);
unsigned char i2c_read_byte();
unsigned char i2c_delay(unsigned int delay);



void i2c_start()
{
    SCL_SET;       //SCL=1;
    i2c_delay(I2C_SPEED);
    SDA_RESET;     //SDA=0;
    i2c_delay(2*I2C_SPEED);
    SCL_RESET;     //SCL=0;
    i2c_delay(I2C_SPEED);
}

void i2c_stop()
{
	SDA_WRITE_MODE;   //TRISBbits.TRISB5=0;
    i2c_delay(I2C_SPEED);
    SCL_SET;         //SCL=1;
    i2c_delay(2*I2C_SPEED);
    SDA_SET;         //SDA=1;
    i2c_delay(I2C_SPEED);
}

void i2c_send_bit(unsigned char send_bit)
{
	SDA_READ_MODE;   //TRISBbits.TRISB5=0; //output
    if (send_bit) SDA_SET; else SDA_RESET; //SDA=(send_bit)?1:0;
    i2c_delay(I2C_SPEED);
    SCL_SET;        //SCL=1;
    i2c_delay(2*I2C_SPEED);
    SCL_RESET;      //SCL=0;
    i2c_delay(I2C_SPEED);
}

unsigned char i2c_read_bit()
{
   unsigned char read_bit;
   SDA_READ_MODE;    //LATBbits.LATB5=1; //Z
   i2c_delay(I2C_SPEED);
   SCL_SET;          //SCL=1;
   i2c_delay(I2C_SPEED);
   read_bit=SDA;   //read_bit=PORTBbits.RB5;
   i2c_delay(I2C_SPEED);
   SCL_RESET;      //SCL=0;
   i2c_delay(I2C_SPEED);
   return read_bit;
}

unsigned char i2c_send_byte(unsigned char send_byte)
{
    unsigned char i;
    for (i=0;i<8;i++)
    {
        switch(i)
        {
            case 0: {i2c_send_bit(send_byte&BIT7);} break;
            case 1: {i2c_send_bit(send_byte&BIT6);} break;
            case 2: {i2c_send_bit(send_byte&BIT5);} break;
            case 3: {i2c_send_bit(send_byte&BIT4);} break;
            case 4: {i2c_send_bit(send_byte&BIT3);} break;
            case 5: {i2c_send_bit(send_byte&BIT2);} break;
            case 6: {i2c_send_bit(send_byte&BIT1);} break;
            case 7: {i2c_send_bit(send_byte&BIT0);} break;
        }
    }
    return 1;
}

unsigned char i2c_read_byte()
{
    unsigned char i;
    unsigned char read_byte=0;
    for (i=0;i<8;i++)
    {
        switch(i)
        {
            case 0: { read_byte|=(i2c_read_bit())?BIT7:0; } break;
            case 1: { read_byte|=(i2c_read_bit())?BIT6:0; } break;
            case 2: { read_byte|=(i2c_read_bit())?BIT5:0; } break;
            case 3: { read_byte|=(i2c_read_bit())?BIT4:0; } break;
            case 4: { read_byte|=(i2c_read_bit())?BIT3:0; } break;
            case 5: { read_byte|=(i2c_read_bit())?BIT2:0; } break;
            case 6: { read_byte|=(i2c_read_bit())?BIT1:0; } break;
            case 7: { read_byte|=(i2c_read_bit())?BIT0:0; } break;
        }
    }
    SDA_READ_MODE;    //TRISBbits.TRISB5=0;
    return read_byte;
}

unsigned char read_ack()
{
    unsigned char ack;
    SDA_READ_MODE; //LATBbits.LATB5=1; //input
    i2c_delay(I2C_SPEED);
    SCL_SET;       //SCL=1;
    i2c_delay(I2C_SPEED);
    ack=SDA;      //PORTBbits.RB5;
    i2c_delay(I2C_SPEED);
    SCL_RESET;     //SCL=0;
    i2c_delay(I2C_SPEED);
    //TRISBbits.TRISB5=0; //output
    return ack;
}

unsigned char write_ack(unsigned char ack)
{
    //TRISBbits.TRISB5=0; //output
    if (ack) SDA_SET; else SDA_RESET;   //SDA=(ack)?0:1;
    i2c_delay(I2C_SPEED);
    SCL_SET;    //SCL=1;
    i2c_delay(2*I2C_SPEED);
    SCL_RESET;    //SCL=0;
    i2c_delay(I2C_SPEED);
    //TRISBbits.TRISB5=1; //input
    return ack;
}

unsigned char i2c_delay(unsigned int delay)
{
    int i;
    for (i=delay;i>0;i--) {}
    return 1;
}

void i2c_init()
{
	IOWR_ALTERA_AVALON_PIO_CLEAR_BITS(I2C_PORT_BASE, BIT1); //Output 0 - on SDA
    SDA_SET;   //SDA=1;
    SCL_SET;   //SCL=1;
}

void write_command (unsigned char reg_addr, unsigned char data)
{
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_WR);
   read_ack();
   i2c_send_byte(reg_addr);
   read_ack();
   i2c_send_byte(data);
   read_ack();
   i2c_stop();
}

void write_command_multiple (unsigned char reg_addr, unsigned char *data, unsigned char size)
{
   unsigned char i = 0;
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_WR);
   read_ack();
   i2c_send_byte(reg_addr);
   read_ack();
   for (i=0;i<size;i++)
   {
   i2c_send_byte(data[i]);
   read_ack();
   }
   i2c_stop();
}

unsigned char read_command (unsigned char reg_addr)
{
   unsigned char buf_data;
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_WR);
   read_ack();
   i2c_send_byte(reg_addr);
   read_ack();
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_RD);
   read_ack();
   buf_data=i2c_read_byte();
   write_ack(1);
   i2c_stop();
   return buf_data;
}

unsigned short read_word_command (unsigned char reg_addr)
{
   unsigned short buf_data;
   unsigned char msb,lsb;
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_WR);
   read_ack();
   i2c_send_byte(reg_addr);
   read_ack();
   i2c_start();
   i2c_send_byte(I2C_ACCEL_ADDR_RD);
   read_ack();
   msb=i2c_read_byte();
   write_ack(1);
   lsb=i2c_read_byte();
   write_ack(0);
   i2c_stop();
   buf_data=(msb<<8)&0xff00;
   buf_data|=lsb;
   return buf_data;
}
