// #include "types.h"
// #include "stat.h"
// #include "user.h"

// int
// main(int argc, char *argv[])
// {
	  // if(cowfork() > 0)
		// sleep(5);  // Let child exit before parent.
		// printf(1,"7");
	// exit();
	
	// test t3
	// int *p = (int*) main;
	// int j;
	// printf(1, "main add: %d\n", (int)*main);
	// for ( j = 0 ; j <0x1000 ; j++, p++)
	// {
		// *p= 0;
	// printf(1, "p: %p, *p :%d, *main: %d\n", p, *p,*main);		
	// }
	// printf(1, "main add: %d\n", (int)*main);
	// printf(1, "main add1: %p\n", main);	
	// printf(1, "main add2: %p\n", main);
	// printf(1, "main add3: %p\n", main);
	// printf(1, "main add4: %p\n", main);
	// printf(1, "main add5: %p\n", main);
	// printf(1, "main add6: %p\n", main);
	// printf(1, "main add7: %p\n", main);
	// printf(1, "main add8: %p\n", main);
	// printf(1, "main add9: %p\n", main);
	// printf(1, "main add10: %p\n", main);
    
	// test t2
	// char *buf = 0;
    // buf[0] = 'a';
    // printf(1, "in 0 we have: ");
	// char *p = 0;
	// printf(1, "%s, buf[0]: %s", *p, buf[0]);
	// exit();
// }

#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	int i, pid;
	int *malloced_array[5];
	int *malloced_int;
	char *malloced_char;
	malloced_int = (int *)malloc(sizeof(int));
	malloced_char= (char *)malloc(sizeof(char));
	*malloced_int = 0;
	*malloced_char = 'a';
		printf(1,"malloced_int = %d\n",  *malloced_int);
		printf(1,"malloced_char = %c\n", *malloced_char);
	
	for(i = 0; i < 5 ; i++){
		malloced_array[i] = (int *)malloc(1000*sizeof(int));
		malloced_array[i][0] = i;
		printf(1,"malloced_array[%d][0] = %d\n", i, malloced_array[i][0]);
	}

	printf(1,"cowforking 3 child\n");	
		pid = cowfork();
	if(pid)
		pid = cowfork();
	if(pid)
		pid = cowfork();
		
	//if(!pid) //child
			printf(1," in child: cowforked 1\n");	
			
	
	
	if(pid)
		printf(1,"finished cowforking 3 childs\n");

	printf(1,"proc %d is now sleeping\n", getpid());
	sleep(700);
	
	if(pid)
		printf(1, "changing values of malloced array\n");
	
	for(i = 0; i < 5 && (getpid()%2 == 0); i++){ //son
		printf(1,"malloced_arrayin proc %d  pre-change :[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
		malloced_array[i][0] = i*3*getpid();
		printf(1,"malloced_arrayin proc %d after change:[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
	}
	if(pid)
		printf(1,"changed value to even processes\n");
	sleep(700);
	
	for(i = 0; i < 5 && (getpid()%2 == 0); i++){ //pid % 2 = 0
		printf(1,"proc %d malloced_arrayin :[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
		}

	for(i = 0; i < 5 && (getpid()%2 == 1); i++){ //pid % 2 = 1
		printf(1,"proc %d malloced_arrayin pre change :[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
		malloced_array[i][0] = i*10*getpid();
		printf(1,"proc %d malloced_arrayin after change:[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
	}
	// for(i = 0; i < 5 && pid; i++){ 
		// printf(1,"malloced_arrayin father pre change :[%d][%d] = %d\n", i, i, malloced_array[i][0]);
		// malloced_array[i][0] = i*20;
		// printf(1,"malloced_arrayin father after chnage:[%d][%d] = %d\n", i, i, malloced_array[i][0]);
	// }
	if(pid)
		printf(1, "changed all malloced array in all procs\n");
	sleep(700);
	// for(i = 0; i < 5 && pid; i++){
	// printf(1,"malloced_arrayin father [%d][%d] = %d\n", i, i, malloced_array[i][0]);
	// }
	for(i = 0; i < 5 ; i++){ //printing values of the malloced array
		printf(1,"proc %d malloced_array at:[%d][0] = %d\n",getpid(), i, malloced_array[i][0]);
		sleep(200);
	}
	for(i = 0; i < 3 && pid; i++){
	wait();
	}
	//sleep(400);
	exit();
	
}
	
	
	
	
	
	
	