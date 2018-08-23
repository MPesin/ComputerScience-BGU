#include <stdio.h>
# define MAX_LEN 100     /* Maximal line size */

extern int do_Str (char*);

int main(void) {

  char str_buf[MAX_LEN];   
  int counter = 0;
  
  fgets(str_buf, MAX_LEN, stdin);  /* Read user's command line string */ 
 
  counter = do_Str (str_buf);  	 /* Your assembly code function */

  printf("%s%d\n",str_buf,counter);
  return 0;

}
