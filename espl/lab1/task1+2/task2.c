#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int existInArgs(char * c, char ** argv);

void task2(char * name, char **argv) {
    printf("%s",name);
    FILE * out = fopen (name,"w");
    char c; 
    int i;
    if(existInArgs("-l", argv) > 0){    
        char arr[8];
        while ((c = getchar())!=EOF) {
            if (c != '\n') {
                for (i=0; i<8; i++) {
                    arr[i] = (c>>i & 1);
                    fprintf(out,"%i",arr[i]);
                }                
                fprintf(out," ");
            } else
                fprintf(out,"\n");
        }                   
    } else if(existInArgs("-b", argv) > 0){
        char arr[8];
        while ((c = getchar())!=EOF) {
        if (c != '\n') {
            for (i=7; i>=0; i--){
                arr[i] = (c>>i & 1);
                fprintf(out,"%i",arr[i]);
            }
            fprintf(out," ");
        } else
            fprintf(out,"\n");
        }  
    }
    else {
        while ((c = getchar())!=EOF) {
        if (c != '\n') {
                fprintf(out,"%d ",c);
            }else
                fprintf(out,"\n");
        }  
    }
    fclose(out);
}