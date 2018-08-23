#include "types.h"
#include "stat.h"
#include "user.h"

void
regular_demo()
{
   int pid = getpid();
   int *x = (int *)malloc(sizeof(int));
   int *grade = (int*)malloc(sizeof(int));
   *grade = 100;
   *x = 0;
   int *y = (int *)malloc(sizeof(int));
   *y = 100; // GRADE?!#!##$

   printf(1, "pid : %d x: %d y: %d grade: %d \n\n", pid, *x, *y, *grade);
   printf(1, "Fater Process <procdump> Before Forking \n\n");
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();
   //child
   if (fork() == 0)
   {

     printf(1, "CHILD before changing X same address -copied\n");
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
     procdump();
     *x=2;
     printf(1, "CHILD after changing X address\n");
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
     procdump();
//     // now we can see that before changing x it was a shared memory
//     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
   } else {
	   wait();
	   printf(1, "Fater Process <procdump> After Cow_Forking \n\n");
	   procdump();
   }
}

void
cow_demo()
{
   int pid = getpid();
   int *x = (int *)malloc(sizeof(int));
   int *grade = (int*)malloc(sizeof(int));
   *grade = 100;
   *x = 0;
   int *y = (int *)malloc(sizeof(int));
   *y = 100; // GRADE?!#!##$

   printf(1, "pid : %d x: %d y: %d grade: %d \n\n", pid, *x, *y, *grade);
   printf(1, "Fater Process <procdump> Before Forking \n\n");
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();

   //child
   if (cowfork() == 0)
   {

     printf(1, "CHILD before changing X same address -copied\n");
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
     procdump();
     *x=2;
     printf(1, "CHILD after changing X same address\n");
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
     procdump();
//     // now we can see that before changing x it was a shared memory
//     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
   } else {
	   wait();
	   printf(1, "Fater Process <procdump> After Cow_Forking \n\n");
	   procdump();
   }
   exit();
}
int
main(int argc, char *argv[])
{
	printf(1,"Regular fork demonstration:\n\n");
	regular_demo();
	printf(1,"COW demonstration:\n\n");
	cow_demo();
	exit();

}

