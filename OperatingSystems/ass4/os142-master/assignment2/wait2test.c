// Test that fork fails gracefully.
// Tiny executable so that the limit can be filling the proc table.

#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000
/*
void
printf(int fd, char *s, ...)
{
  write(fd, s, strlen(s));
}
*/

void
foo()
{
  int i;
  for (i=0;i<100;i++)
     printf(2, "wait test %d\n",i);
  sleep(20);
  for (i=0;i<100;i++)
     printf(2, "wait test %d\n",i);

}

void
waittest(void)
{
  int wTime;
  int rTime;
  int ioTime;
  int pid;
  printf(1, "wait test\n");


    pid = fork();
    if(pid == 0)
    {
      foo();
      exit();      
    }
    wait2(&wTime,&rTime,&ioTime);
     printf(1, "wasting time for wait2 \n");
    printf(1, "wTime: %d rTime: %d ioTime: %d \n",wTime,rTime, ioTime);

}

void
sigh(void)
{
 printf(1,"Wabalabadubdub!\n");
}

int
main(void)
{
  //waittest();
 /* int pid = fork();
  if (pid == 0)
  {
    if (signal(2,&sigh) != 0)
	printf(1,"Failed to register new signal handler\n");
    sleep(50);
    exit();
  }else{
  sleep(200);
  sigsend(pid,2);
  wait();
}*/
 //signal(2,&sigh);
 //sigsend(getpid(),2);
 signal(14,&sigh);
 alarm(5);
 sleep(6);
 exit();
} 
