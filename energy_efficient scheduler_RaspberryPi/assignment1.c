#include <stdio.h>
#include <wiringPi.h>
#include <softPwm.h>
#include <stdint.h>
#include "assignment1.h"

void init_shared_variable(SharedVariable* sv) {
	// You can initialize the shared variable if needed.
	sv->bProgramExit = 0;
	sv->push_button=0;
	sv->temperature=0;
	sv->track_obj=0;
	sv->shock_obj=0;
	sv->reset=1;
	sv->dead=0;
	sv->pressed=0;
	sv->depressed=0;
	sv->state=0;
	sv->idle=0;
	sv->i=0;
	sv->ii=0;
	sv->low=0;
	sv->high=0;
	sv->prev_time=0;
	sv->energy=0;
	sv->select[0]=0;
	sv->select[1]=0;
	sv->select[2]=0;
	sv->select[3]=0;
	sv->select[4]=0;
	sv->select[5]=0;
	sv->select[6]=0;
	sv->select[7]=0;
	sv->next_deadline[0]=9223372036854775807;
        sv->next_deadline[1]=9223372036854775807;
        sv->next_deadline[2]=9223372036854775807;
        sv->next_deadline[3]=9223372036854775807;
        sv->next_deadline[4]=9223372036854775807;
        sv->next_deadline[5]=9223372036854775807;
        sv->next_deadline[6]=9223372036854775807;
        sv->next_deadline[7]=9223372036854775807;
	sv->exetime_high[0]=0;
        sv->exetime_high[1]=0;
        sv->exetime_high[2]=0;
        sv->exetime_high[3]=0;
        sv->exetime_high[4]=0;
        sv->exetime_high[5]=0;
        sv->exetime_high[6]=0;
        sv->exetime_high[7]=0;
	sv->exetime_low[0]=0;
        sv->exetime_low[1]=0;
        sv->exetime_low[2]=0;
        sv->exetime_low[3]=0;
        sv->exetime_low[4]=0;
        sv->exetime_low[5]=0;
        sv->exetime_low[6]=0;
        sv->exetime_low[7]=0;
	sv->prev_alive_tasks[0]=0;
        sv->prev_alive_tasks[1]=0;
        sv->prev_alive_tasks[2]=0;
        sv->prev_alive_tasks[3]=0;
        sv->prev_alive_tasks[4]=0;
        sv->prev_alive_tasks[5]=0;
        sv->prev_alive_tasks[6]=0;
        sv->prev_alive_tasks[7]=0;
	sv->a[0]=0;
        sv->a[1]=0;
        sv->a[2]=0;
        sv->a[3]=0;
        sv->a[4]=0;
        sv->a[5]=0;
        sv->a[6]=0;
        sv->a[7]=0;
        sv->ab[0]=0;
        sv->ab[1]=0;
        sv->ab[2]=0;
        sv->ab[3]=0;
        sv->ab[4]=0;
        sv->ab[5]=0;
        sv->ab[6]=0;
        sv->ab[7]=0;
        sv->b[0]=0;
        sv->b[1]=0;
        sv->b[2]=0;
        sv->b[3]=0;
        sv->b[4]=0;
        sv->b[5]=0;
        sv->b[6]=0;
        sv->b[7]=0;
        sv->critical=-1;
}
void init_sensors(SharedVariable* sv) {

	//initialize the pins of the Raspberry Pi
	pinMode(PIN_BUTTON,INPUT);
	pinMode(PIN_TEMP,INPUT);
	pinMode(PIN_TRACK,INPUT);
	pinMode(PIN_SHOCK,INPUT);
	pinMode(PIN_ALED,OUTPUT);
	digitalWrite(PIN_ALED, LOW);
	pinMode(PIN_RED,OUTPUT);
	pinMode(PIN_GREEN,OUTPUT);
	pinMode(PIN_BLUE,OUTPUT);
	pinMode(PIN_YELLOW,OUTPUT);
	digitalWrite(PIN_YELLOW, LOW);
	pinMode(PIN_BUZZER,OUTPUT);
	digitalWrite(PIN_BUZZER, LOW);
	softPwmCreate(7,0,100);
        softPwmCreate(8,0,100);
        softPwmCreate(9,0,100);
        softPwmWrite(PIN_RED, 0);
        softPwmWrite(PIN_GREEN, 0);
        softPwmWrite(PIN_BLUE, 0);
}

void body_button(SharedVariable* sv) {
/*	//sv->bProgramExit = 1;
	int value1,value2;
	value1=digitalRead(PIN_BUTTON);
	//delay(10);
	value2=digitalRead(PIN_BUTTON);
	if(value1==0&&value2==0)
	{
		sv->pressed=1;
		sv->depressed=0;
		if(sv->dead==1)
		{
			sv->dead=0;
			sv->reset=1;
		}
		else{
			if(sv->reset==1)
				sv->reset=0;
			else
				sv->reset=1;
		}
		while(1)
		{
			value1=digitalRead(PIN_BUTTON);
			//delay(10);
			value2=digitalRead(PIN_BUTTON);
			//delay(10);
			if(value1==1&&value2==1)
			{
				break;
			}
		}
		sv->push_button=1;
	}
	else
		sv->push_button=0;
}
*/
	int value1,value2;
	value1=digitalRead(PIN_BUTTON);
//	delay(10);
	value2=digitalRead(PIN_BUTTON);
	if(value1==0&&value2==0)
	{
		//if(sv->dead==1)
		//{
		//	sv->dead=0;
		//	sv->reset=1;
		//}
		//else{
			//if(sv->pressed==0){
			//if(sv->reset==0)
			//	sv->reset=1;
			//else
			//	sv->reset=1;
			//}
		//}
		sv->pressed=1;
		sv->depressed=0;
	}
	if(sv->pressed==1&&sv->depressed==0)
	{
		value1=digitalRead(PIN_BUTTON);
//		delay(10);
		value2=digitalRead(PIN_BUTTON);
		if(value1==1&&value2==1)
		{
			if(sv->dead==1)
        	        {
                	        sv->dead=0;
                        	sv->reset=1;
                	}
			else{
//				sv->pressed=0;
//				sv->depressed=1;
//				sv->push_button=1;
				if(sv->pressed==1){
                        	if(sv->reset==0)
                        	        sv->reset=1;
                       		else
                              		sv->reset=0;
                        	}
			}
                        sv->pressed=0;
                        sv->depressed=1;
                        sv->push_button=1;
		}
		else
		sv->push_button=0;
	}
}
void body_twocolor(SharedVariable* sv) {
	if(sv->dead!=1){
	if(sv->push_button==1)
	{
		if(sv->reset==0)
		{
			digitalWrite(PIN_YELLOW, HIGH);//two color=yellow
		}
		else
			digitalWrite(PIN_YELLOW, LOW);//two color=yellow
	}
	sv->push_button=0;
	}
}

void body_temp(SharedVariable* sv) {
	volatile int value1,value2;
	value1=digitalRead(PIN_TEMP);
	//delay(20);
	value2=digitalRead(PIN_TEMP);
	if(value1==1&&value2==1)
		sv->temperature=1;
	else
		sv->temperature=0;
}

void body_track(SharedVariable* sv) {
	if(sv->dead!=1){
	int value1=digitalRead(PIN_TRACK);
//	if(sv->i==0)
//		printf("track value %d \n",value1);
	if(digitalRead(PIN_TRACK)==LOW && sv->reset==0)
		sv->track_obj=1;
	else
		sv->track_obj=0;
	}
}

void body_shock(SharedVariable* sv) {
	if(sv->dead!=1){
        int value1=digitalRead(PIN_SHOCK);
//        printf("value1=%d\n",value1);
//	if(sv->i==0)
//		printf("shock value %d \n",value1);
        if(digitalRead(PIN_SHOCK)==HIGH && sv->reset==0)
        {
//                printf("shock = on \n");
                sv->shock_obj=1;
        }
        else
	         sv->shock_obj=0;
        }
	sv->i=1;
}

void body_rgbcolor(SharedVariable* sv) {
	if(sv->dead!=1){
	if(sv->reset==1)
	{
//                softPwmWrite(PIN_RED, 0); //rgb=blue
//                softPwmWrite(PIN_GREEN, 0);
//                softPwmWrite(PIN_BLUE, 0);
                softPwmWrite(PIN_RED, 0); //rgb=blue
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 100);
	}
	else
	{
		if(sv->track_obj==1 && sv->reset==0)
		{
//                softPwmWrite(PIN_RED, 0);
//                softPwmWrite(PIN_GREEN, 0);
//                softPwmWrite(PIN_BLUE, 0);
                softPwmWrite(PIN_RED, 46); //rgb=magenta
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 93);
		sv->dead=1;
//		delay(1000);
		}
                else if(sv->shock_obj==1 && sv->reset==0)
                {
//                        softPwmWrite(PIN_RED, 0);
//                        softPwmWrite(PIN_GREEN, 0);
//                        softPwmWrite(PIN_BLUE, 0);
                        softPwmWrite(PIN_RED, 100); //rgb=red
                        softPwmWrite(PIN_GREEN, 0);
                        softPwmWrite(PIN_BLUE, 0);
 //                       printf("RGB=red\n");
			sv->dead=1;
//			delay(1000);
                }
		else
		{
//                	softPwmWrite(PIN_RED, 0);
//                	softPwmWrite(PIN_GREEN, 0);
//                	softPwmWrite(PIN_BLUE, 0);
	               	softPwmWrite(PIN_RED, 0); //rgb=green
                	softPwmWrite(PIN_GREEN, 100);
                	softPwmWrite(PIN_BLUE, 0);
//			sv->reset=0;
//			delay(1000);
		}
	}
	}
}

void body_aled(SharedVariable* sv) {
	if(sv->reset!=1){
	if(sv->temperature==1)
		digitalWrite(PIN_ALED,HIGH);
	else
		digitalWrite(PIN_ALED,LOW);
	}
}

void body_buzzer(SharedVariable* sv) {
	if(sv->reset!=1){
	if(sv->temperature==1)
		digitalWrite(PIN_BUZZER,HIGH);
	else
		digitalWrite(PIN_BUZZER,LOW);
	}
}
