#ifndef TASK1A
#define TASK1A

typedef struct diff {
    long offset;
    unsigned char orig_value;   
    unsigned char new_value;     
} diff;

typedef struct node node;
 
struct node {
    diff *diff_data; 
    node *next;
};

void list_print(node *diff_list);

node* list_append(node* diff_list, diff* data); 

void list_free(node *diff_list);

#endif