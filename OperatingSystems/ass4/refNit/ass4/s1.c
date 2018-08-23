#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "param.h"

int
main(int argc, char *argv[]) {
    
    int res;
    
    if (argc < 2){
        printf(1,"readlink: Not enough arguments.\n");
        exit();
    }
    
    char *path = argv[1];
    printf(1,"readlink: trying to dereference %s\n",path);
    
    char buf[MAXPATH];
    
    if ((res = readlink(path, buf, MAXPATH)) < 0){
        printf(1,"readlink: syscall readlink() failed - returned %d\n",res);
        exit();
    }else{
        printf(1,"readlink: syscall readlink() returned %s\n",buf);
        printf(1,"readlink: read %d bytes\n",res);
        exit();
    }
    
}
