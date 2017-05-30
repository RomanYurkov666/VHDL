/*
 * rangefinder.c
 *
 *  Created on: 25.01.2017
 *      Author: Igor
 */
#include "system.h"
#include "pc_com.h"
#include "rangefinder.h"
#include "laser_driver.h"
#include "tdc7200.h"
#include "altera_avalon_pio_regs.h"

typedef enum
{
  st_idle = 0x0,
  st_sample_recording = 0x1,
  st_computing_rms = 0x2,
  st_calibrating = 0x3
} calibrate_states;

alt_u8 G_noise_rms = 0;
alt_u8 state = st_idle;
alt_u8 next_state = st_idle;
alt_u8 sample_ready = 0;
alt_u8 rms_ready = 0;
alt_u8 calibrating_complete = 0;
alt_u8 record_delay_cnt = 0;
alt_u8 current_amp_gain = 0;
alt_u16 iteration_cnt = 0;

alt_u8 compute_rms();
void calibrating_iteration();
const alt_u8 filter_size = RMS_FILTER_SIZE;
const alt_u8 half_filter = RMS_FILTER_SIZE/2;
const alt_u8 noise_rms_dest = 25*2/3; //25 = 0.1 V, ADCref = 1V; RMS ~= AVG/3
const alt_u8 noise_toler = 10;
/*
 *  При минимальном напряжении на ЛФД, закрытой диафрагме приемной оптики повысить коэфф. усиления электронного тракта
до достижения уровня шума, измеренного АЦП приблизительно 0,1 - 0,2  В (средневыпрямленного). Повышать напряжение ЛФД
до двух - трехкратного увеличения уровня шума.  Рабочая точка  - 0,9..0.95 от измеренного напряжения (может уточняться).
Этот способ точнее.
 */


void ProcCmd_Rangefinder(t_pc_cmd *cmd)
{
	switch (cmd->data[0])
	{
	case dev_start_meas:
		{
			tdc_start_measure(); //Стартуем TDC
			generate_charge_pulse(332000,0); //Генерируем импульс зарядки лазера толстый 1866 мкс = 373200
			generate_laser_pulse(280000, 42000); //350000 Генерируем импульс разрешения лазера 1600 мкс = 320 с опазданием 210 мкс = 42000
			generate_tdc_start_pulse(100 ,42000); //Стартовый импульс для TDC
		}
		break;
	case dev_sys_mux_switch_test:
		{
			IOWR_ALTERA_AVALON_PIO_DATA(SYSTEM_MODE_BASE, 0);
		} break;
	case dev_sys_mux_switch_normal:
		{
			IOWR_ALTERA_AVALON_PIO_DATA(SYSTEM_MODE_BASE, 1);
		} break;
	}
}

void calibrate_photodetector()
{
	next_state = st_sample_recording;
}

void photodetector_calibrating_routine()
{
	//signals
	if ((state == st_idle)&&(state == st_sample_recording)) //first input
	{
		current_amp_gain = 0;
		set_APD_ref_source(0); //минимум
		set_VGA_gain(current_amp_gain); //минимум
		//start_sample_record(64);
		sample_ready=0;
		rms_ready=0;
	}

	if (state == st_sample_recording) //delay
	{
		record_delay_cnt++;
		if (record_delay_cnt>=10)
		{
			record_delay_cnt=0;
			//stop_sample_record();
			sample_ready = 1;
		}
	}
	else
	{
		record_delay_cnt = 0;
	}

	//fsm
	state=next_state;
	switch(state)
	{
		case st_idle:
			{
				next_state = st_idle;
			} break;
		case st_sample_recording:
			{
			  if (sample_ready)
			  {
				  sample_ready = 0;
				  next_state = st_computing_rms;
			  }
			} break;
		case st_computing_rms:
			{
				compute_rms();
				next_state = st_calibrating;
				rms_ready = 1;
			} break;
		case st_calibrating:
			{
			  calibrating_iteration();

			  if (calibrating_complete)
			  {
				  calibrating_complete=0;
				  next_state=st_idle;
			  }
			  else
			  {
				  next_state = st_sample_recording;
			  }

			} break;
		default:
			{
			next_state=st_idle;
			} break;
	}
}

alt_u8 compute_rms()
{
	alt_u8 *sample = get_sample(0);
	alt_16 filtered_sample[256];
	alt_16 i = 0;
	alt_16 fi = 0;
	alt_u16 sum = 0;
	float rms = 0.0;
	alt_u16 avg_signal = 0;


	for (i=0;i<256;i++)
	{
		sum = 0;
		for (fi=i-half_filter;fi<=i+half_filter;fi++)
		{
			if ((fi>=0)&&(fi<=255))
				sum+=sample[fi];
		}
		sum=sum/filter_size;
		filtered_sample[i]=sum;
	}
	for (i=0;i<256;i++)
	{
		filtered_sample[i]=sample[i]-filtered_sample[i];
		avg_signal += filtered_sample[i];
	}
	avg_signal=avg_signal/256; //Должен быть примерно 0

	for (i=0;i<256;i++)
	{
		rms+=pow(filtered_sample[i]-avg_signal,2);
	}
	rms=rms/256;
	rms=sqrt(rms);
	return (alt_u8)rms;
}

void calibrating_iteration()
{
	G_noise_rms = compute_rms();
	if (G_noise_rms<noise_rms_dest-noise_toler)
	{
		current_amp_gain++;
		set_VGA_gain(current_amp_gain);
	}
	else if (G_noise_rms>noise_rms_dest+noise_toler)
	{
		current_amp_gain--;
		set_VGA_gain(current_amp_gain);
	}
	else
	{
		calibrating_complete=1;
	}

	iteration_cnt++;
	if (iteration_cnt>64)
	{
		iteration_cnt=0;
		calibrating_complete=1;
	}

}
