#include <stdio.h>
#include <string.h>
 
void echo_printer(char c){
    printf("%c ",c);
}/* task 0 from lab1 - prints c to the standard output*/

void ascii_printer(char c){
        printf("%i ", c);
}/* task 1a from lab1 - convert a char to its ascii code and print it to the standard output*/

void binary_printer(char c){
    char arr[8];
    int i;
    for (i=0; i<8; i++) {
        arr[i] = (c>>i & 1);
        printf("%i",arr[i]);
    }
    printf(" ");
} /* task 1c from lab1 - convert a char to its ascii 
                            code in binary (most to least representation) and print it to the standard output*/ 
 
void string_printer(char* str, void (*f) (char)){
    int i;
    int l = sizeof(str)/sizeof(str[0]);
    for (i=0; i<l; i++){
        (*f)(str[i]);
    }
    printf("\n");
}
 
void string_reader(char* s){
    printf("enter string: ");
    fgets(s, 10, stdin);
    
}
 
int main(int argc, char **argv){
    /*char c = getchar();
    echo_printer(c);
    ascii_printer(c);
    binary_printer(c);*/
    char str[10];
    int i[1];
    string_reader(str);
    printf("choose printing method: 1 - echo_printer, 2 - ascii_printer or 3 - binary_printer");
    scanf("%i", i);
    void (*f) (char);
    if (*i==1)
        f = &echo_printer;
    if (*i==2)
        f = &ascii_printer;
    if (*i==3)
        f = &binary_printer;
    string_printer(str, f);
    return 0;
}