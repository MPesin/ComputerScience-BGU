#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_OF_CHILDRENS 10
#define NUM_OF_CHILD_LOOPS 1000

int main(int argc, char *argv[])
{
	int i,j,index,wTime,rTime,ioTime = 0;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (i=0 ; i < NUM_OF_CHILDRENS && fork_id !=0; i++) {
		fork_id = fork();
		if (fork_id == 0) {
			for (j=0 ; j < NUM_OF_CHILD_LOOPS ; j++)
				printf(2,"child <%d> prints for the <%d>\n",getpid(),j);
			exit();
		}
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {
		c_array[index][0] = fork_id;
		c_array[index][1] = wTime;	// waiting time
		c_array[index][2] = rTime;	// run time
		c_array[index][3] = wTime+ioTime+rTime; // turnaround time -> end time - creation time
		index++;
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
	}
	exit();

}
