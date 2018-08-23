#include "types.h"
#include "stat.h"
#include "user.h"


int
main(int argc, char *argv[])
{
   char *buf = 0;
   printf(1,"trying to access ADDRESS 0\n");
   buf[0] = 'a';
   exit();
}
