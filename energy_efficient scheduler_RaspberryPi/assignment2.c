#include "assignment1.h"
#include "assignment2.h"
#include "workload.h"
#include "scheduler.h"
#include "governor.h"

// Note: Deadline of each workload is defined in the "workloadDeadlines" variable.
// i.e., You can access the dealine of the BUTTON thread using workloadDeadlines[BUTTON]
// See also deadlines.c and workload.h

// Assignment: You need to implement the following two functions.

// learn_workloads(SharedVariable* v):
// This function is called at the start part of the program before actual scheduling
// - Parameters
// sv: The variable which is shared for every function over all threads
void learn_workloads(SharedVariable* sv) {
	// TODO: Fill the body
	// This function is executed before the scheduling simulation.
	// You need to calculate the execution time of each thread here.

	// Thread functions for workloads:
	// thread_button, thread_twocolor, thread_temp, thread_track,
	// thread_shock, thread_rgbcolor, thread_aled, thread_buzzer

	// Tip 1. You can call each workload function here like:
	// thread_button();

	// Tip 2. You can get the current time here like:
	// long long curTime = get_current_time_us();
	set_by_min_freq();
	long long metric;
        long long curTime_before = get_current_time_us();
        long long curTime_after = get_current_time_us()-curTime_before;
	int i;

	max=0;
	for(i=0;i<20;i++)
	{
        	curTime_before=0;
        	curTime_after=0;
        	curTime_before = get_current_time_us();
		thread_button(sv);
       	 	curTime_after = get_current_time_us()-curTime_before;
		if(max<curTime_after)
		{
			max=curTime_after;
		}
                sv->exetime_low[0]=max;
	}

	max=0;
        for(i=0;i<20;i++)
	{
		curTime_before=0;
		curTime_after=0;
		curTime_before = get_current_time_us();
       	 	thread_twocolor(sv);
       		curTime_after = get_current_time_us()-curTime_before;
        	//sv->exetime_low[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_low[1]=max;
	}


        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_temp(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_low[2]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_track(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_low[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_low[3]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_shock(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_low[4]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_rgbcolor(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_low[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_low[5]=max;
        }


        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_aled(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_low[6]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_buzzer(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_low[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_low[7]=max;
        }

        set_by_max_freq();
        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_button(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_high[0]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_twocolor(sv);
                curTime_after = get_current_time_us()-curTime_before;
                //sv->exetime_high[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_high[1]=max;
        }


        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_temp(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_high[2]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_track(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_high[1]=curTime_after;
                if(max<curTime_before)
		{
                        max=curTime_after;
                }
                sv->exetime_high[3]=max;
        }

	 max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_shock(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_high[4]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_rgbcolor(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_high[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_high[5]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_aled(sv);
                curTime_after = get_current_time_us()-curTime_before;
                if(max<curTime_after)
		{
                        max=curTime_after ;
                }
                sv->exetime_high[6]=max;
        }

        max=0;
        for(i=0;i<20;i++)
	{
                curTime_before=0;
                curTime_after=0;
                curTime_before = get_current_time_us();
                thread_buzzer(sv);
                curTime_after = get_current_time_us()-curTime_before;
               // sv->exetime_low[1]=curTime_after;
                if(max<curTime_after)
		{
                        max=curTime_after;
                }
                sv->exetime_high[7]=max;
	}

//	int i;
	for(i=0;i<NUM_TASKS;i++)
	{
		if( ( (float)sv->exetime_high[i] )/10000 > sv->exetime_high[i]/10000)
			sv->b[i]=sv->exetime_high[i]/10000+1;
		else
			sv->b[i]=sv->exetime_high[i]/10000;
                if( ( (float)sv->exetime_low[i] )/10000 > sv->exetime_low[i]/10000)
                        sv->ab[i]=sv->exetime_low[i]/10000+1;
                else
                        sv->ab[i]=sv->exetime_low[i]/10000;
		sv->a[i]=(float)sv->ab[i]/(float)sv->b[i];
		if(sv->a[i]>2)
			sv->select[i]=1;
		else
			sv->select[i]=0;
	}
	//for(i=0;i<NUM_TASKS;i++)
	//{
	//	printDBG(" %lld , %lld , %d \n",sv->exetime_low[i],sv->exetime_high[i],sv->select[i]);
	//}
	set_by_max_freq();
	float metic,critical,max1;
	max1=0;
	for(i=0;i<NUM_TASKS;i++)
	{
		metric=(float)sv->exetime_low[i]/(float)workloadDeadlines[i];
		if(max1<metric)
		{
			max1=metric;
			critical=i;
		}
	}
	sv->critical=critical;
	sv->prev_time=get_current_time_us();
}


// select_task(SharedVariable* sv, const int* aliveTasks):
// This function is called while runnning the actual scheduler
// - Parameters
// sv: The variable which is shared for every function over all threads
// aliveTasks: an array where each element indicates whether the corresponed task is alive(1) or not(0).
// idleTime: a time duration in microsecond. You can know how much time was waiting without any workload
//           (i.e., it's larger than 0 only when all threads are finished and not reache the next preiod.)
// - Return value
// TaskSelection structure which indicates the scheduled task and the CPU frequency
TaskSelection select_task(SharedVariable* sv, const int* aliveTasks, long long idleTime) {
	// TODO: Fill the body
	// This function is executed inside of the scheduling simulation.
        // You need to implement an energy-efficient EDF (Earliest Deadline First) scheduler.

	// Tip 1. You may get the current time elapsed in the scheduler here like:
	// long long curTime = get_scheduler_elapsed_time_us();

	// Also, do not make any interruptable / IO tasks in this function.
	// You can use printfDBG instead of printf.

	// Sample scheduler: Round robin
	// It selects a next thread using aliveTasks.
	static int prev_selection = -1;
	int i = prev_selection+1,p;
	long long next_deadline[NUM_TASKS],curr_time,EarliestDeadline,slack,minslack,total,FarthestDeadline,maxslack,extime=0,diff=0;
	//static long long time_for_energy=get_current_time_us();
	float energy=0;
	while(1)
	{
		if (i == NUM_TASKS)
			i = 0;

		if (aliveTasks[i] == 1) {
			break;
		}
		++i;
	}
	//printf("hi\n");
	curr_time=get_current_time_us();
//        static long long time_for_energy=curr_time;
	int min = -1;
	int  max=-1;
	int keep[8];
	EarliestDeadline= 9223372036854775807;
	FarthestDeadline=0;
	total=0;
	minslack=EarliestDeadline;
	maxslack=0;
//	printDBG("[%d %d]",aliveTasks[0],aliveTasks[1]);
	for(p=0;p<NUM_TASKS;p++)
	{
		if(aliveTasks[p]==1)
		{
			if(sv->prev_alive_tasks[p]==0)
				sv->next_deadline[p]=curr_time+workloadDeadlines[p];
			slack=sv->next_deadline[p]-curr_time;
			if(minslack>slack)
			{
				minslack=slack;
				EarliestDeadline=sv->next_deadline[p];
				min=p;
//				printf("%d",min);
			}
			if(maxslack<slack)
			{
				maxslack=slack;
				FarthestDeadline=sv->next_deadline[p];
				max=p;
			}
		}
		keep[p]=sv->prev_alive_tasks[p];
		sv->prev_alive_tasks[p]=aliveTasks[p];
	}
//	printDBG("%d\n",min);
        curr_time=get_current_time_us();
	prev_selection=min;
	int k,no;
	for(k=0;k<NUM_TASKS;k++)
	{
		if(aliveTasks[k]==1)
		{
			no=(FarthestDeadline-curr_time)/workloadDeadlines[k];
			if((FarthestDeadline-curr_time) < workloadDeadlines[k])
				no=1;
		}
		else
			no=(FarthestDeadline-curr_time)/workloadDeadlines[k];
		total=total+no*sv->exetime_low[k];

	}
	total=total-(sv->exetime_high[min])+(sv->exetime_low[min]);
	TaskSelection sel;
	sel.task=prev_selection;
	if(total<((FarthestDeadline-curr_time)+10000))
	{
		if(sv->select[prev_selection]==0)
		{
			sel.freq=1;
			sv->low++;
		}
		else
		{
			sel.freq=1;
			sv->high++;
		}
	}
	else
	{
        	if( ((int)(sv->exetime_low[prev_selection] - 10000/sv->a[prev_selection])/10000) < sv->ab[prev_selection] && keep[prev_selection]==0)
		{
			if(sv->select[prev_selection]==0)
			{
				sel.freq=1;
				sv->low++;
			}else
			{
				sel.freq=1;
				sv->high++;
			}
		}
		else
		{
			sel.freq=1;
			sv->high++;
		}
	}
	sv->idle=sv->idle+idleTime;
//	printDBG("%d",sel.task);
	if(sv->ii==0)
	{
		extime=0;
		sv->ii++;
	}
	else
        	extime=curr_time-sv->prev_time-idleTime;
        if(sel.freq==0)
               sv->energy=sv->energy+extime*0.4+idleTime*0.05;
        else
               sv->energy=sv->energy+extime*0.8+idleTime*0.05;
//	if(idleTime>0)
//	printDBG("energy=%lld exe_time  %lld idle time %lld \n",sv->energy,extime,sv->idle);
	sv->prev_time=get_current_time_us();
//	TaskSelection sel;
//	sel.task=0;
//	sel.freq=1;
//	printDBG("task = %d\n",prev_selection);
	return sel;
}

