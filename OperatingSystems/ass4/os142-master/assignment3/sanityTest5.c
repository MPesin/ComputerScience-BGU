#include "types.h"
#include "stat.h"
#include "user.h"


int
main(int argc, char *argv[])
{
   int pid = getpid();
   int *x = (int *)malloc(sizeof(int));
   int *grade = (int*)malloc(sizeof(int));
   *grade = 100;
   *x = 0;
   int i;
   int *malloced_array[5];
   
   for(i = 0; i < 5 ; i++){
		malloced_array[i] = (int *)malloc(1000*sizeof(int));
		malloced_array[i][0] = i;
		printf(1,"malloced_array[%d][0] = %d\n", i, malloced_array[i][0]);
	}
   
   int *y = (int *)malloc(sizeof(int));
   *y = 100; // GRADE?!#!##$
   
   printf(1, "pid : %d x: %d y: %d grade: %d \n\n\n\n", pid, *x, *y, *grade);
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();
   
   //child
   if (cowfork() == 0)
   {
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n", getpid(), *x, *y, *grade);
     printf(1, "before changing X same address\n\n\n\n\n");
     procdump();
     *x=2;
     printf(1, "after changing X different address\n\n\n\n");
     procdump();
     // now we can see that before changing x it was a shared memory
     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
     
     //child of child
     if (cowfork() == 0){
       
       printf(1, "before changing Y same address\n\n\n\n");
       procdump();
       *y = 200;
       printf(1, "after changing Y different address\n");
       printf(1,"pid is : %d, x: %d, y: %d , grade: %d \n\n\n\n\n", getpid(), *x, *y, *grade);
       procdump();
       exit();
    }
    else{
       wait();
       procdump();
       exit();
    }
   }
   
   //parent
   else
   {
     wait();
     printf(1,"pid is : %d , x is %d, y is %d , grade: %d \n", pid, *x, *y, *grade);
     printf(1, "ALL CHILDREN DIED \n\n\n\n\n");
     procdump();
     
     //test 2
     if (cowfork() == 0)
     {
       char *buf = 0;
       printf(1, "son is trying to write to 0\n");
       buf[0] = 'a';
       printf(1, "This line will never printed");
       exit();
     }
     else
     {
       wait();
       if (cowfork() == 0)
       {
	 char* pointer = (char*)main;
	 printf(1, "read from pointer main %c \n", *pointer);
	 printf(1, "son is trying to write to pointer main\n");
         *pointer = 'n';
         printf(1, "This line will never printed");
       }
       else
       {
	 wait();
       }
     }
       
   }
     free(y);
     free(x);
     free(grade);
     exit();
}
