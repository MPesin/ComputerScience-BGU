#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main()
{
  char buf[512];
  int fd, i,j;
  char a;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(2, "big: cannot open big.file for writing\n");
    exit();
  }
  a = 'A';
  for (i=0; i<1024; i++){
    for (j=0; j<1024; j++){
      *(char*)buf = a;
      int cc = write(fd, buf, sizeof(buf));
      if(cc <= 0){
    	  break;
      }
    }
    if (i == 5)
      printf(1, "Finished writing 6KB (direct)\n");
    if (i == 69)
      printf(1, "Finished writing 70KB (single indirect)\n");
    if (i == 1023)
      printf(1, "Finished writing 1MB\n");
  }

  close(fd);

  exit();
}
