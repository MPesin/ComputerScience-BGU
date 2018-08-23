#define STACK_SIZE  4096
#define MAX_UTHREADS  64
#define UTHREAD_QUANTA 8
#include "types.h"

/********  Task 2 *********/

// Inline assembly macros 
#define STORE_ESP(var) 	asm("movl %%esp, %0;" : "=r" ( var ))
#define LOAD_ESP(var) 	asm("movl %0, %%esp;" : : "r" ( var ))
#define STORE_EBP(var) 	asm("movl %%ebp, %0;" : "=r" ( var ))
#define LOAD_EBP(var) 	asm("movl %0, %%ebp;" : : "r" ( var ))
#define CALL(addr)		asm("call *%0;" : : "r" ( addr ))
#define PUSH(var)		asm("movl %0, %%edi; push %%edi;" : : "r" ( var ))
#define RET			asm("ret;")
#define PUSHAL			asm("pushal;")
#define POPAL			asm("popal;")


typedef enum  {T_FREE, T_RUNNING, T_RUNNABLE, T_SLEEPING} uthread_state;
typedef struct uthread uthread_t, *uthread_p;
typedef struct uthread_table uthread_table;

struct uthread {
	int		tid;
	uint 	       	esp;        		/* current stack pointer */
	uint 	       	ebp;			/* current base pointer */
	void		*stack;	    		/* the thread's stack */
	uthread_state   state;     		/* running, runnable, sleeping, free */
	int		firstrun;   		/* holds 1 if thread didnt run yet, 0 otherwise */
	void		(*entry)(void *);	/* entry function for uthread */
	void            *value;			/* argument for entry function */
};

struct uthread_table{
	uthread_p threads[MAX_UTHREADS];
	uthread_p runningThread;
	int threadCount;

};

uthread_table threadTable;

void uthread_init(void);
int  uthread_create(void (*func)(void *), void* value);
void wrapper(void);
void uthread_exit(void);
void uthread_yield(void);
int  uthread_self(void);
int  uthread_join(int tid);
void uthread_sleep(void);
void uthread_wakeup(int tid);

/********  Task 3 *********/
struct binary_semaphore {
	int				value;					
	int				waiting[MAX_UTHREADS];
	int				counter;
};

void binary_semaphore_init(struct binary_semaphore* semaphore, int value);
void binary_semaphore_down(struct binary_semaphore* semaphore);  
void binary_semaphore_up(struct binary_semaphore* semaphore);
void printQueue(struct binary_semaphore* semaphore);

