#include "types.h"
#include "stat.h"
#include "user.h"
#include "uthread.h"
#define S_Q 0
#define S_R 1
#define S_L 2
#define S_S 3
#define S_ASTRIX 4
#define S_F 5 
#define S_E -1

/****** Task 4 - FSSP problem  ******/

struct  {
	int counter;
	int size;
	struct binary_semaphore arr_sem;
	struct binary_semaphore dep_sem;
} barrier ;

int sol_num = 0 ;
int CURRENT_STATE = 1;
int A_STATES[MAX_UTHREADS];
int B_STATES[MAX_UTHREADS];

int states[4][5][5] = {
/*  				Q				  			R								L						S						*				  */
/*		    Q    R    L    S    *	    Q    R    L    S    *       Q    R    L    S    *      Q    R    L    S    *      Q    R    L    S    * 	*/
/* Q */	{ {S_Q, S_Q, S_L, S_Q, S_Q},  {S_R, S_R, S_E, S_E, S_R},  {S_Q, S_E, S_L, S_S, S_Q}, {S_Q, S_S, S_E, S_E, S_E}, {S_Q, S_Q, S_L, S_Q, S_E} },
/* R */	{ {S_R, S_R, S_Q, S_L, S_E},  {S_Q, S_R, S_L, S_E, S_L},  {S_S, S_E, S_Q, S_F, S_E}, {S_Q, S_R, S_L, S_E, S_L}, {S_S, S_E, S_Q, S_F, S_E} },
/* L */	{ {S_L, S_S, S_Q, S_Q, S_E},  {S_Q, S_Q, S_R, S_R, S_Q},  {S_L, S_E, S_L, S_L, S_E}, {S_R, S_F, S_E, S_E, S_F}, {S_E, S_E, S_R, S_R, S_E} },
/* S */	{ {S_Q, S_S, S_L, S_Q, S_E},  {S_R, S_E, S_E, S_F, S_E},  {S_S, S_E, S_E, S_S, S_E}, {S_Q, S_S, S_F, S_E, S_E}, {S_Q, S_S, S_F, S_E, S_E} },
};

void initializeBarrier(int size) {
	barrier.counter = 0;
	barrier.size = size;
	binary_semaphore_init(&barrier.arr_sem,1);
	binary_semaphore_init(&barrier.dep_sem,0);
}

int next_state(int index) {
	int center, left, right, nextState;
	int (*currStates)[sol_num];
	int (*nextStates)[sol_num];
	if (CURRENT_STATE == 1) {
		currStates = &A_STATES;
		nextStates = &B_STATES;
	}
	else {
		currStates = &B_STATES;
		nextStates = &A_STATES;
	}

	center = (*currStates)[index];
	left = (index==0) ? S_ASTRIX : (*currStates)[index-1];
	right = (index == sol_num-1) ? S_ASTRIX : (*currStates)[index+1];

	nextState = states[center][left][right];
	(*nextStates)[index] = nextState;

	return nextState;
}

void statesPrinter() {
	int (*currStates)[sol_num];
	int i;
	if (CURRENT_STATE == 1){
		currStates = &A_STATES;
	}
	else{
		currStates = &B_STATES;
	}
	for (i = 0; i < sol_num ; i++) {
		printf(1," %d ", (*currStates)[i]);
	}
	printf(1,"\n");
}

void barrier_func(){
	binary_semaphore_down(&barrier.arr_sem);
	barrier.counter++;
	if (barrier.size > barrier.counter){
		binary_semaphore_up(&barrier.arr_sem);
	}
	else {
		alarm(0);
		statesPrinter();
		CURRENT_STATE = 1 - CURRENT_STATE;
		alarm(UTHREAD_QUANTA);
		binary_semaphore_up(&barrier.dep_sem);
	}
	binary_semaphore_down(&barrier.dep_sem);
	barrier.counter--;
	if (barrier.counter > 0)
		binary_semaphore_up(&barrier.dep_sem);
	else
		binary_semaphore_up(&barrier.arr_sem);
}

void initStates() {
	int i;
	A_STATES[0]  = S_R;
	for (i = 1; i < sol_num; i++){
		A_STATES[i]  = S_Q;
	}
}

void soldier(void* ind){
	int index,state;
	index =(int)((int *) ind);
	state = S_Q ;
	while (state != S_F) {
		state =	next_state(index);
		barrier_func();
	}
}

int main(int argc, char **argv) {
	int threads[MAX_UTHREADS],i;
	if (argc < 2) {
		printf(1,"ERROR: Not enough arguments, usage: FSSP <number> \n");
		exit();
	}
	sol_num = atoi(argv[1]);
	if (sol_num > MAX_UTHREADS) {
		printf(1,"ERROR: More soldiers than threads\n");
		exit();
	}

	uthread_init(); 
	initializeBarrier(sol_num); 
	
	/* Initialize states */
	A_STATES[0]  = S_R;
	for (i = 1; i < sol_num; i++){
		A_STATES[i]  = S_Q;
	}

	for (i=0; i < sol_num; i++){
		threads[i] = uthread_create(soldier,(void*)i);
	}

	for (i=0; i < sol_num; i++){
		uthread_join(threads[i]);
	}
	statesPrinter();

	exit();
	return 0;
}

