/*
 * export.c
 *
 *  Created on: Mar 23, 2014
 *      Author: nitay
 */
#include "types.h"
#include "user.h"
#include "our_header.h"


void export(char* buf)
{
  int next_c,i = 0;
  char tempPath[MAX_ENTRY_LEN] = "";

  while(*buf != 0 && *buf != '\n' && *buf != '\t' && *buf != '\r' && *buf != ' ') {
    if(*buf != ':') {
    	tempPath[next_c] = *buf;
    	next_c++;
    }
    else	// : delimiter , new path
    {

      tempPath[next_c] = 0; // NULL terminated
      add_path(tempPath);
      for (i = 0 ; i < strlen(tempPath) ; i++) {
    	  tempPath[i] = *"";
      }
      next_c = 0;
    }
    buf++;
  }
}

int
main(int argc, char *argv[])
{
  if(argc < 2){
    exit();
  }
  export(argv[1]);
  exit();
}
