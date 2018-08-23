#include <stdio.h>

extern int funcA(char * ch1);

int main(int argc, char **argv){
    char str[5];
    printf("enter a string please:\n");
    scanf("%s", str);
    int l = funcA(str);
    printf("the length is:%i\n", l);
    return 0;
}