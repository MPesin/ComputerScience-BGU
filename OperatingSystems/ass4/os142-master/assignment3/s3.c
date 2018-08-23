#include "types.h"
#include "stat.h"
#include "user.h"


int
main(int argc, char *argv[])
{
   char* pointer = (char*)main;

   if(fork() == 0) {
    printf(1, "read from pointer %c \n", *pointer);
     printf(1, "son is trying to write to main (which is read only)\n");
     *pointer = 'n';
   } else
     wait();// father waiting


   exit();
   
}
