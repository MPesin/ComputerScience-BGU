#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void task1a() {    
    char c;    
    while ((c = getchar())!=EOF) {
      if (c != '\n') {
            printf("%d ",c);
        }else
            printf("\n");
    }    
}