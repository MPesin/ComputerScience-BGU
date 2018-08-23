#include <stdlib.h>
#include <stdio.h>
#include "task1a.h"



void list_print(node *diff_list){
    /*int i;
    for (i=0; i<n; i++)*/
    printf("List Print: ");
    while (diff_list->next != NULL){
        diff toPrint = *(diff_list->diff_data);
        printf("byte %ld %02X %02X", toPrint.offset, toPrint.orig_value, toPrint.new_value);
        diff_list++;
    }
    
}

node* list_append(node* diff_list, diff* data){
    node* of_data = (node*) malloc(sizeof(struct node));
    of_data->diff_data = data;
    diff* temp0 = of_data->diff_data;
    printf("offset; %ld\n", temp0->offset);
    of_data->next = NULL;
    if (diff_list == NULL)
        return of_data;
    node* ans = diff_list;
    while (diff_list->next != NULL){
        /*diff* temp = diff_list->diff_data;
        printf("offset; %ld\n", temp->offset);*/
        diff_list++;
    }
    diff_list->next = of_data;
    return ans;
}

void list_free(node *diff_list){
    while (diff_list != NULL){
        free(diff_list->diff_data);
        free(diff_list);
        diff_list++;
    }
} 

