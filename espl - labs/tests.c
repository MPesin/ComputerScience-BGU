#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct list{
    int data;
    struct list* next;
};

void makeList(struct list* list1){
    list1 = (struct list*) malloc(sizeof(struct list));
    list1->next = NULL;
}

int main (int argc, char** argv){
    struct list* list1;
    makeList(list1);
    list->data = 5;
    printf("data: %d\n", list1-data);
}