#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void task1c() {    
    char c; 
    int i;
    char arr[8];
    while ((c = getchar())!=EOF) {
      if (c != '\n') {
        for (i=7; i>=0; i--){
            arr[i] = (c>>i & 1);
            printf("%i",arr[i]);
        }
        printf(" ");
      } else
        printf("\n");
    }    
}