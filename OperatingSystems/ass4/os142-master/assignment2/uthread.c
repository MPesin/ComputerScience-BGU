#include "uthread.h"
#include "user.h"
#include "signal.h"
#include "x86.h"

extern void alarm(int ticks);

/********  Task 2 Implementation  *********/

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
}

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
		threadTable.threads[i] = 0;
	}
	
	// Initialize main thread
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
	STORE_ESP(threadTable.threads[0]->esp);
	STORE_EBP(threadTable.threads[0]->ebp);
	threadTable.threads[0]->state = T_RUNNING;
	threadTable.runningThread = threadTable.threads[0];
	threadTable.threadCount = 1;
	
	// Register yield as SIGALRM handler
	signal(SIGALRM, uthread_yield);
	alarm(UTHREAD_QUANTA);
}

int  uthread_create(void (*func)(void *), void* value)
{
	alarm(0);
	int current = findNextFreeThreadId();
	if (current == -1)
		return -1;
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
	threadTable.threads[current]->tid = current;
	threadTable.threads[current]->firstrun = 1;
	threadTable.threadCount++;
	threadTable.threads[current]->entry = func;
	threadTable.threads[current]->value = value;
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
	
	threadTable.threads[current]->state = T_RUNNABLE;
	alarm(UTHREAD_QUANTA);
	return current;
}

void uthread_exit(void)
{
	
	// Free current thread's resources
	if (threadTable.runningThread->tid)
		free(threadTable.runningThread->stack);
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
	free(threadTable.runningThread);
	
	threadTable.threadCount--;
	
	if (threadTable.threadCount == 0){
		exit();
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
	threadTable.runningThread->state = T_RUNNING;
	alarm(UTHREAD_QUANTA);
	LOAD_ESP(threadTable.runningThread->esp);
	LOAD_EBP(threadTable.runningThread->ebp);
	
	if (threadTable.runningThread->firstrun){
		threadTable.runningThread->firstrun = 0;
		wrapper();
	}
	

}

void uthread_yield(void)
{
	// Store context of current thread
	STORE_ESP(threadTable.runningThread->esp);
	STORE_EBP(threadTable.runningThread->ebp);

	if (threadTable.runningThread->state == T_RUNNING)
		threadTable.runningThread->state = T_RUNNABLE;
	
	// Move on to next thread
	threadTable.runningThread = findNextRunnableThread();
	threadTable.runningThread->state = T_RUNNING;
	
	alarm(UTHREAD_QUANTA);
	LOAD_ESP(threadTable.runningThread->esp);
	LOAD_EBP(threadTable.runningThread->ebp);
	if (threadTable.runningThread->firstrun){
		threadTable.runningThread->firstrun = 0;
		CALL(wrapper);
		asm("ret");
	}
	
	return;
}

void wrapper(void)
{
	threadTable.runningThread->entry(threadTable.runningThread->value);
	uthread_exit();
}

int uthread_self(void)
{
	return threadTable.runningThread->tid;
}

int uthread_join(int tid)
{
	if (tid > MAX_UTHREADS)
		return -1;
	while (threadTable.threads[tid]) {}
	return 0;
}

/****** Task 3 Implementation ******/

void uthread_wakeup(int tid)
{
	threadTable.threads[tid]->state = T_RUNNABLE;
}

void uthread_sleep(void)
{
	threadTable.runningThread->state = T_SLEEPING;
	uthread_yield();
}

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
}

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
	semaphore->value = value;
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
		semaphore->waiting[i] = -1;
	}
}

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
	alarm(0);
	if (semaphore->value ==0){
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
		uthread_sleep();
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
	semaphore->value = 0;
	alarm(UTHREAD_QUANTA);
}

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
	alarm(0);
	
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
		if (minIndex != -1){
			uthread_wakeup(minIndex);
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
	
}
