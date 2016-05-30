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
	sv-state=0;
	sv->aled_etime=1;
	sv->buzzer_etime=1;
	sv->yellow_etime=2;
	sv->rgb_etime=6;
	sv->temp_etime=1.5;
	sv->track_etime=3;
	sv->shock_etime=3;
	sv->pb_etime=15;
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
	value2=digitalRead(PIN_BUTTON);
	if(value1==0&&value2==0)
	{
		if(sv->dead==1)
		{
			sv->dead=0;
			sv->reset=1;
		}
		else{
			if(sv->reset==1&&sv->pressed=0)
				sv->reset=0;
			else
				sv->reset=1;
		}
		sv->pressed=1;
		sv->depressed=0;
	}
	if(sv->pressed=1&&sv->depressed=0)
	{
		value1=digitalRead(PIN_BUTTON);
		value2=digitalRead(PIN_BUTTON);
		if(value1==1&&value2==1)
		{	
			sv->pressed=0;
			sv->depressed=1;
			sv->push_button=1;
			sv->reset=0;				
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
        if(digitalRead(PIN_SHOCK)==HIGH && sv->reset==0)
        {
//                printf("shock = on \n");
                sv->shock_obj=1;
        }
        else
	         sv->shock_obj=0;
        }

}

void body_rgbcolor(SharedVariable* sv) {
	if(sv->dead!=1){
	if(sv->reset==1)
	{
                softPwmWrite(PIN_RED, 0); //rgb=blue
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 0);
                softPwmWrite(PIN_RED, 0); //rgb=blue
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 100);
	}
	else
	{
		if(sv->track_obj==1 && sv->reset==0)
		{
                softPwmWrite(PIN_RED, 0);
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 0);
                softPwmWrite(PIN_RED, 46); //rgb=magenta
                softPwmWrite(PIN_GREEN, 0);
                softPwmWrite(PIN_BLUE, 93);
		sv->dead=1;
		}
                else if(sv->shock_obj==1 && sv->reset==0)
                {
                        softPwmWrite(PIN_RED, 0);
                        softPwmWrite(PIN_GREEN, 0);
                        softPwmWrite(PIN_BLUE, 0);
                        softPwmWrite(PIN_RED, 100); //rgb=red
                        softPwmWrite(PIN_GREEN, 0);
                        softPwmWrite(PIN_BLUE, 0);
 //                       printf("RGB=red\n");
			sv->dead=1;
                }
		else
		{
                	softPwmWrite(PIN_RED, 0);
                	softPwmWrite(PIN_GREEN, 0);
                	softPwmWrite(PIN_BLUE, 0);
	               	softPwmWrite(PIN_RED, 0); //rgb=green
                	softPwmWrite(PIN_GREEN, 100);
                	softPwmWrite(PIN_BLUE, 0);
			//sv->reset=0;
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
