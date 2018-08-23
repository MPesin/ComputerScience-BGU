#include <stdio.h>

extern int my_cmp(char ch1, char ch2);

int main(int argc, char **argv){
  int res;
  
  if (argc != 3){
    fprintf(stderr,"Usage: task0 char1 char2 \n");
    return 0;
  }
  
  char ch1 = *(*(argv+1));
  char ch2 = *(*(argv+2));
  
  res = my_cmp(ch1,ch2);
  if (res == 1)
	printf("The %dst argument is bigger \n",res);
	else
	printf("The %dnd argument is bigger \n",res);
	
  return 0;
}