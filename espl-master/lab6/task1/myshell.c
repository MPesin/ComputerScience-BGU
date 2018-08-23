#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "LineParser.h"

#define HISTORY_SIZE  10

void execute(cmdLine *pCmdLine);
char * getInput();
void my_cd(cmdLine *pCmdLine);
void addToHistory(char * in);
void printHistory();

pid_t to_exec;
int status;
char current_dir[1024];

typedef struct History{
    char *cmd_a[HISTORY_SIZE];
    int index;
} History;

History his = {.index = 0};

int main (int argc , char* argv[]) {
    char * in;
    while( 1 ) {
        getcwd(current_dir, sizeof(current_dir));
        printf("\n%s$> ",current_dir);
        in = getInput();
        cmdLine *pCmdLine = parseCmdLines(in);
        if (pCmdLine == NULL) 
            break;
        if (strcmp(pCmdLine->arguments[0],"cd") == 0) 
            my_cd(pCmdLine);
        else if (strcmp(pCmdLine->arguments[0],"history") == 0) 
            printHistory();
        else if (strcmp(pCmdLine->arguments[0],"quit") == 0){
                freeCmdLines(pCmdLine);
                break;
            } else {
                    to_exec = fork();
                    if (to_exec == -1){
                        perror("fork"); 
                        exit(EXIT_FAILURE); 
                    }
                    if (to_exec == 0){
                        execute(pCmdLine);
                    } else {
                        if (pCmdLine->blocking)
                            waitpid(to_exec, &status, 0);
                    }
            }
        addToHistory(in);
        freeCmdLines(pCmdLine);
    }
    return 0;
}

void execute(cmdLine *pCmdLine)  {
    if (pCmdLine == NULL) {
        return;
    }
    int i;
    printf("Executing '%s':\n",pCmdLine->arguments[0]);
    for (i=1; i< pCmdLine->argCount; i++) {
        printf("%s\n", pCmdLine->arguments[i]);
    }

    int result = execvp(pCmdLine->arguments[0], pCmdLine->arguments);
    printf("\n Result: \n %d \n ", result);
    if (result == -1) {
        perror(" Execution failed!\n");
        _exit(2);
    }
    execute(pCmdLine->next);
}


char * getInput() {
    char * line = malloc(2048);
    char * linep = line;
    size_t lenmax = 100;
        size_t len = lenmax;
    int c;

    if(line == NULL)
        return NULL;

    for(;;) {
        c = fgetc(stdin);
        if(c == EOF || c == '\n')
      break;

        if(--len == 0) {
            len = lenmax;
            char * linen = realloc(linep, lenmax *= 2);

            if(linen == NULL) {
                free(linep);
                return NULL;
            }
            line = linen + (line - linep);
            linep = linen;
        }

        *line++ = c;
    }
    
    *line = '\0';
    return linep;
}

void my_cd(cmdLine *pCmdLine){ 
    int result = chdir(pCmdLine->arguments[1]);
    if (result == -1) 
        perror(" cd failed!");
}

void addToHistory(char * in){
    if (his.index < HISTORY_SIZE)
        his.cmd_a[his.index++] = in;
    else {
        int k;
        for (k = his.index; k > 0; k--){   
            his.cmd_a[k]=his.cmd_a[k-1];
        }
        his.cmd_a[his.index] = in;
    }
}

void printHistory(){
    char **to_p = his.cmd_a;
    int i = 0;
    while (i<his.index && *to_p != NULL){
        /*if (to_p != ) */
            printf("%i. %s\n", 1+(i++), *to_p);
        to_p++;
    }
}
        