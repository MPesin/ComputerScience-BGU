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
#define CONST_SIZE 1024

typedef struct History{
    char *cmd_a[HISTORY_SIZE];
    int index;
} History;

void execute(cmdLine *pCmdLine);
void getInput(char * in);
void my_cd(cmdLine *pCmdLine);
void addToHistory(History *his, char * in);
void printHistory(History *his);
void clearHistory(History *his);

pid_t to_exec;
int status;
char current_dir[CONST_SIZE];

int main (int argc , char* argv[]) {
    char * in = malloc(CONST_SIZE);
    History * his = malloc(sizeof(History));
    *his = (History) {.index = 0};
    while( 1 ) {
        getcwd(current_dir, sizeof(current_dir));
        printf("\n%s$> ",current_dir);
        getInput(in);
        cmdLine *pCmdLine = parseCmdLines(in);
        if (pCmdLine == NULL) 
            break;
        if (strcmp(pCmdLine->arguments[0],"cd") == 0) 
            my_cd(pCmdLine);
        else if (strcmp(pCmdLine->arguments[0],"history") == 0) 
            printHistory(his);
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
        addToHistory(his,in);
        freeCmdLines(pCmdLine);
    }
    free(in);
    clearHistory(his);
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


void getInput(char * line) {
    char * linep = line;
    size_t lenmax = 100;
    size_t len = lenmax;
    int c;

    if(line == NULL)
        line = NULL;

    for(;;) {
        c = fgetc(stdin);
        if(c == EOF || c == '\n')
            break;

        if(--len == 0) {
            len = lenmax;
            char * linen = realloc(linep, lenmax *= 2);

            if(linen == NULL) {
                free(linep);
                line = NULL;
            }
            line = linen + (line - linep);
            linep = linen;
        }

        *line++ = c;
    }
    line = linep;
}

void my_cd(cmdLine *pCmdLine){ 
    int result = chdir(pCmdLine->arguments[1]);
    if (result == -1) 
        perror(" cd failed!");
}

void addToHistory(History *his, char * in){
    char *copy = malloc(CONST_SIZE);
    strcpy(copy,in);
    if (his->index < HISTORY_SIZE)
        his->cmd_a[his->index++] = copy;
    else {
        int k;
        for (k = his->index; k > 0; k--){   
            his->cmd_a[k]=his->cmd_a[k-1];
        }
        his->cmd_a[his->index] = copy;
    }
}

void printHistory(History *his){
    char **to_p = his->cmd_a;
    int i = 0;
    while (i<his->index && *to_p != NULL){
        printf("%i. %s\n", 1+(i++), *to_p);
        to_p++;
    }
}

void clearHistory(History *his){
    int i = 0;
    while (i<his->index && *his->cmd_a != NULL){
        free(his->cmd_a[i]);
        i++;
    }
    free(his);
}
        