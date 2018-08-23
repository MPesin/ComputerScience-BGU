#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void task1a();
void task1b();
void task1c();
void task2(char * name, char **argv);

int existInArgs(char * c, char ** argv){
    int i;
    int l = sizeof(argv)/sizeof(argv[0]);
    for (i=0; i<l; i++){
        if ((strcmp(argv[i], c) == 0))
            return i;
    }
    return 0;
}


int main(int argc, char **argv) {
    int i;
    if (argc>1) {
        if((i = existInArgs("-o", argv)) > 0)
            task2(argv[i+1], argv);
        if(existInArgs("-l", argv) > -1)
            task1b();
        if(existInArgs("-b", argv) > -1)
            task1c();
    } else
        task1a();
    return 0;
}