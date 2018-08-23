#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct printer{
    char * name;
    void (*f) (char);
} printer;
 
void echo_printer(char c){
    printf("%c",c);
}/* task 0 from lab1 - prints c to the standard output*/

void ascii_printer(
    char c){
        printf("%i", c);
}/* task 1a from lab1 - convert a char to its ascii code and print it to the standard output*/

void binary_printer(char c){
    char arr[8];
    int i;
    for (i=0; i<8; i++) {
        arr[i] = (c>>i & 1);
        printf("%i",arr[i]);
    }
} /* task 1c from lab1 - convert a char to its ascii 
                            code in binary (most to least representation) and print it to the standard output*/ 
 
void string_printer(char* str, void (*f) (char)){
    for (; * str; str++){
        (*f)(*str);
        printf(" ");
    }
    printf("\n");
}
 
void string_reader(char* s){
    printf("enter string (up to 10 chars): ");
    fgets(s, 10, stdin);
    
}

int checkI(int i, int lim){
    if (i<1 || i>lim)
        return 0;
    return 1;
}
 
int main(int argc, char **argv){
    char str[10];
    int i, j = 0;
    char c;
    printer printers[3] = {{"echo printer",echo_printer},{"ascii printer", ascii_printer},{"binary printer", binary_printer}};
    string_reader(str);
    printf("choose printing method:\n");
    int l = sizeof(printers)/sizeof(printers[0]);
    for (j=0; j<l; j++){
        printf("%i) %s\n", j+1, printers[j].name);
    }
    while ((c = getchar()) != EOF){
        if (c == '\n')
            continue;
        i =  atoi(&c);
        if (checkI(i, l)==0){
            printf("Number invalid, try again\n");
            continue;
        }
        string_printer(str, printers[i-1].f);
    }
    return 0;
}