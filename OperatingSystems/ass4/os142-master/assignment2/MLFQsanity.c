#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_OF_CHILDRENS 20
#define NUM_OF_CHILD_LOOPS 500

int waste_time_function() {
	int sum = 0;
	int i,j,k = 0;
	for (i =0 ; i < 1750 ; i++) {
		for (j = 0 ; j < i ; j++) {
			for (k = 0 ; k < j ; k++) {
				sum += 1;
			}
		}
	}
	return sum;
}

int main(int argc, char *argv[])
{
	int i,j,index,wTime,rTime,ioTime,cid,avg_wTime,avg_rTime,avg_turnAround,flag = 0;
	int low_avg_wTime,low_avg_rTime,low_avg_turnAround,high_avg_wTime,high_avg_rTime,high_avg_turnAround;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (cid=0 ; cid < NUM_OF_CHILDRENS; cid++) {
		fork_id = fork();
		if (fork_id == 0) {   // child section
			if ( cid % 2 == 0) {
				waste_time_function();
			} else
				printf(2,"cid <%d> is Activating I/O System Call\n",cid);
			for (i = 0 ; i < NUM_OF_CHILD_LOOPS ; i++) {
				printf(2,"cid <%d>\n",cid);
			}
			exit();			// end of child section
		} else 				// father section starts here
			c_array[cid][0] = fork_id;		// position in array is by CID
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {	// update data for all the childrens
		flag = 0;
		for (index = 0 ; index < NUM_OF_CHILDRENS && !flag ; index++) {
			if (c_array[index][0] == fork_id) {
				c_array[index][1] = wTime;	// waiting time
				c_array[index][2] = rTime;	// run time
				c_array[index][3] = wTime+wTime+rTime; // turnaround time -> end time - creation time
				flag = 1;
			}
		}
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
		avg_wTime += c_array[index][1];
		avg_rTime += c_array[index][2];
		avg_turnAround += c_array[index][3];
		if (index % 2 == 0) {
			low_avg_wTime += c_array[index][1];
			low_avg_rTime += c_array[index][2];
			low_avg_turnAround += c_array[index][3];
		} else {
			high_avg_wTime += c_array[index][1];
			high_avg_rTime += c_array[index][2];
			high_avg_turnAround += c_array[index][3];
		}
	}

	printf(2,"Average waiting time <%d> , Average run time <%d> , Average turnaround time <%d>\n",avg_wTime/NUM_OF_CHILDRENS,avg_rTime/NUM_OF_CHILDRENS,avg_turnAround/NUM_OF_CHILDRENS);
	printf(2,"Average Low Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",low_avg_wTime/(NUM_OF_CHILDRENS/2),low_avg_rTime/(NUM_OF_CHILDRENS/2),low_avg_turnAround/(NUM_OF_CHILDRENS/2));
	printf(2,"Average High Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",high_avg_wTime/(NUM_OF_CHILDRENS/2),high_avg_rTime/(NUM_OF_CHILDRENS/2),high_avg_turnAround/(NUM_OF_CHILDRENS/2));
	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++)
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
	exit();

}
