#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include "LineParser.h"

void execute (char * line);

int main (int argc , char* argv[], char* envp[]) {
   
    int pl[2];
    pid_t child1, child2;

    pipe(pl);
    
    child1 = fork();

    if(child1 == -1){
        perror("fork");
        exit(1);
    }
    if(child1 == 0){
        close(1);
        dup(pl[1]);
        close(pl[1]);
        char *ls = "ls -l";
        execute(ls);
        exit(0);
    } else {
        close(pl[1]);
    }
    
    
    
    child2 = fork();

    if(child2 == -1){
        perror("fork");
        exit(1);
    }
    if(child2 == 0){
        close(0);
        dup(pl[0]);
        close(pl[0]);
        char *tl = "tail -n 2";
        execute(tl);
        exit(0);
    } else {
        close(pl[0]);
    }   
    return 0;
}

void execute (char * in){
    cmdLine *pCmdLine = parseCmdLines(in);
    int result = execvp(pCmdLine->arguments[0], pCmdLine->arguments);
    printf("\n Result: \n %d \n ", result);
    if (result == -1) {
        perror(" Execution failed!\n");
        _exit(2);
    }
    freeCmdLines(pCmdLine);
}