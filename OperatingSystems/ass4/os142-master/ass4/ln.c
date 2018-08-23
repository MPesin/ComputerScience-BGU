#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc < 3){  // task1.b
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(argc == 4 && strcmp(argv[1], "-s") == 0){
  	if(symlink(argv[2], argv[3]) < 0)
   		printf(1, "link -s %s %s: failed\n", argv[2], argv[3]);
  } else if(argc == 3) {
  	if(link(argv[1], argv[2]) < 0)
    	printf(1, "link %s %s: failed\n", argv[1], argv[2]);
  }
  exit();
}
