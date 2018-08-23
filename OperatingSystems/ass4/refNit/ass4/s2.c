#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[]) {
  char *path, *password;
  int pid;
  int fd,n;
  
  if(argc <= 2) {
    printf(2,"not enough arguments\n");
    exit();
  } else {
    path = argv[1];
    password = argv[2];
    fprot(path, password);//Protect the file in the given path with the given password

    pid = fork(); //Use fork:
    
    if (pid == 0) { //Child process
      funlock(path,password);			//a. Unlock the file
      fd = open(path, O_RDONLY);		 //b. Open the file and print its content.
      if (fd<0)
    	  printf(2, "chld_proc: could not open file %s\n", path);
      else {
    	  char buf[512];
    	  printf(1," chld_proc: The file content is \n");
    	  while((n = read(fd, buf, sizeof(buf))) > 0){
    		  printf(1,"%s", buf);
    	  }
    	  printf(1,"\n");
    	  close(fd);  //c. Close the file
      }
      exit();
    } else {
      wait(); 	// a. Wait for child process to die.
      if (open(path, O_RDONLY ) < 0) //	b. Open the file in the given path.
    	  printf(2, "parent_proc: could not open file name: %s\n", path); //c. If the open failed, write failed to open file.
      funprot(path, password); //d. Unprotect the file.
    }
    exit();
  }
}
