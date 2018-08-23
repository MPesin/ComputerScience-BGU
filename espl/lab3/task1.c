#include <stdlib.h>
#include <stdio.h>
#include "task1a.h"
#include "task1b.h"
#include "task1c.h"

int main(int argc, char **argv){
    diff * diff2 = (diff*) malloc(sizeof(diff));
    diff2->offset = 76;
    diff2->orig_value = 1;
    diff2->new_value = 12;
    diff * diff1 = (diff*) malloc(sizeof(diff));
    diff1->offset = 22;
    diff1->orig_value = 99;
    diff1->new_value = 145;    
    node * list = NULL;       
    printf("Starting append \n");
    list = list_append(list,diff1);
    list = list_append(list,diff2);
    printf("finished append\nlist is: %ld \n", list->diff_data->offset);
    list_print(list);
    list_free(list);
    return 0;

}

