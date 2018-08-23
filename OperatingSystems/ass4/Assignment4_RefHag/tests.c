#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"


#define O_RDONLY  0x000
#define O_WRONLY  0x001
#define O_RDWR    0x002
#define O_CREATE  0x200
/*
#undef NULL
#define NULL ((void*)0)
*/

int ppid;
volatile int global = 1;

#define assert(x) if (x) {} else { \
   printf(1, "%s: %d ", __FILE__, __LINE__); \
   printf(1, "assert failed (%s)\n", # x); \
   printf(1, "TEST FAILED\n"); \
   kill(ppid); \
   exit(); \
}


void bigFileTest(){
  char buf[512];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(2, "big: cannot open big.file for writing\n");
    return;
  }

  sectors = 0;
  while(1){
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    sectors++;
    if (sectors % 100 == 0)
        printf(2, ".");
  }

  printf(1, "\nwrote %d sectors\n", sectors);

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf(2, "big: cannot re-open big.file for reading\n");
    return;
  }
  for(i = 0; i < sectors; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      printf(2, "big: read error at sector %d\n", i);
      return;
    }
    if(*(int*)buf != i){
      printf(2, "big: read the wrong data (%d) for sector %d\n",
             *(int*)buf, i);
      return;
    }
  }
  printf(1, "done big file test\n"); 
}

void linkTest(){
  char* oldpath = "oldpath";
  char* newpath = "newpath";
  char* pathname = "pathname";
  char buf[100];
  int bufsize = 2; //size_t

  printf(1, "symlink:\n");
  printf(1, "%d\n", symlink(oldpath, newpath));
  // printf(1, "\n");

  printf(1, "readlink:\n");
  printf(1, "%d\n", readlink(pathname, buf, bufsize));
  // printf(1, "\n");
}

void tagsTest(){
  ppid = getpid();
  int fd = open("ls", O_RDWR);
  printf(1, "fd of ls: %d\n", fd);
  char* key1 = "key1";
  char* key2 = "key2";
  
  char* val1 = "value1";
  char* val2 = "value2";

  char buf[7];

  int res = ftag(fd, key1, val1);
  assert(res > 0);
  res = ftag(fd, key2, val2);
  assert(res > 0);

  gettag(fd, key1, buf);
  printf(1, "buf is: %s\n", buf);

  int i;
  for(i = 0; i < strlen(val1); i++){
    char v_actual = buf[i];
    char v_expected = val1[i];
    assert(v_actual == v_expected);
  }
  
  gettag(fd, key2, buf);
  printf(1, "buf is: %s\n", buf);
  
  for(i = 0; i < strlen(val2); i++){
    char v_actual = buf[i];
    char v_expected = val2[i];
    assert(v_actual == v_expected);
  }

  close(fd);
  printf(1, "TEST PASSED\n");
}



int
main()
{
  //bigFileTest(); 
  linkTest();
  tagsTest();
  exit();
}
    




















