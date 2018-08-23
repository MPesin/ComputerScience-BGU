#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int addr5;
int addr6;

int foo();
void point_at(void *p);

int main (int argc, char** argv){
    int addr2;
    int addr3;
    char* yos="ree";
    int * addr4 = (int*)(malloc(50));
    
    int iarray[3];
    char carray[3];
    
    printf("- &addr2: %p\n",&addr2);
    printf("- &addr3: %p\n",&addr3);
    printf("- foo: %p\n",foo);
    printf("- &addr5: %p\n",&addr5);
    
	point_at(&addr5);
	
    printf("- &addr6: %p\n",&addr6);
    printf("- &addr5: %p\n",&addr5);
    printf("- yos: %p\n",yos);
    printf("- addr4: %p\n",addr4);
    printf("- &addr4: %p\n",&addr4);
    
    printf("- &iarray: %p\n",&iarray[0]);
    printf("- &carray: %p\n",&carray[0]);
    
    printf("- &iarray+1: %p\n",&iarray[0]+1);
    printf("- &carray+1: %p\n",&carray[0]+1);
    
    /*long dist4 = (size_t)&iarray[0]+1 - (size_t)&iarray;
    long dist5 = (size_t)&carray[0]+1 - (size_t)&carray
    
    printf("- &iarray+1 - &iarray: %p\n",dist4);
    printf("- &carray+1 - &carray: %p\n",dist5);*/
    
    return 0;
}

int foo(){
    return -1;
}

void point_at(void *p){
    int local;
	static int addr0 = 2;
    static int addr1;


    long dist1 = (size_t)&addr6 - (size_t)p;
    long dist2 = (size_t)&local - (size_t)p;
    long dist3 = (size_t)&foo - (size_t)p;
    
    printf("dist1: (size_t)&addr6 - (size_t)p: %ld\n",dist1);
    printf("dist2: (size_t)&local - (size_t)p: %ld\n",dist2);
    printf("dist3: (size_t)&foo - (size_t)p:  %ld\n",dist3);
	
	printf("- addr0: %p\n", & addr0);
    printf("- addr1: %p\n",&addr1);
}

