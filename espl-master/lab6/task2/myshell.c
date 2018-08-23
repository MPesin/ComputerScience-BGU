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

typedef struct environment{
    char *name;
    char *value;
} env;

typedef struct node{
    env *key;
    struct node *next;
} node;

node *head;

node *newNode(env *info){
    node *new = malloc(sizeof(node));
    new->key = info;
    new->next = NULL;
    return new;
}

env *newEnv(char *name, char *val){
    env *new = malloc(sizeof(env));
    new->value = val;
    new->name = name;
    return new;
}

void printEnv(env *v){
    char *name = v->name;
    char *value = v->value;
    printf("name: %s value: %s\n", name, value);
}

void addNode(env *add){
    node *toAdd = newNode(add);
    if (head == NULL){
        head = malloc(sizeof(toAdd));
        head = toAdd;
        return;
    }
    node *i = head;
    char *addName = add->name;
    while (i->next != NULL){
        env *temp = i->key;
        if (strcmp(addName, temp->name) == 0){
            //free then malloc new size and then put in
            return;
        } else
            i = i->next;
    }
    i->next = toAdd;
}

void printEnvironment(){
    if (head->next == NULL)
        printEnv(head->key);
    else {
        node *i = head;
        while (i->next != NULL){
            printEnv(i->key);
            i = i->next;
        }
    }
}

char *returnValue(char *name){
    node *i = head;
    while (i->next != NULL){
        char *check = (i->key)->name;
        char *value = (i->key)->value;
        if (strcmp(check, name) == 0)
            return value;
        else 
           i = i->next; 
    }
    return "";
}

int main (int argc , char* argv[]) {
    char * in;
    head = NULL;
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
        }
        else if (strcmp(pCmdLine->arguments[0],"env") == 0){
            printEnvironment();
        }
        else if (strcmp(pCmdLine->arguments[0],"set") == 0){ 
            if (pCmdLine->argCount == 3)
                addNode(newEnv(pCmdLine->arguments[1], pCmdLine->arguments[2]));   
            else{
                perror("syntex error : set <char *> <char *>\n"); 
                exit(2);
            }
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

void checkDollar(cmdLine *pCmdLine){
    int i;
    char *value = malloc(MAX_ARGUMENTS);
    for (i=0; i< pCmdLine->argCount; i++) {
        char *tempArg = pCmdLine->arguments[i]; 
        char tempChar = tempArg[0];
        if (tempChar == '$'){
            strcpy(value,returnValue(tempArg + 1));
            if (strcmp(value, "") != 0){
                replaceCmdArg(pCmdLine, i, value);
            } else {
                perror("No such environment!\n");
                exit(2);
            }
        }
    }
}


void execute(cmdLine *pCmdLine)  {
    if (pCmdLine == NULL) {
        return;
    }

    checkDollar(pCmdLine);

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
        