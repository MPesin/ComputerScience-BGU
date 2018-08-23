#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "cmpstr.c"

int cmpstr(char *char1, char *char2);

extern int cmpstr(char * char1, char * char2);

int main(int argc, char **argv) {
	int cmp;
	char *rel;

	if(argc!=3) {
		fprintf(stderr, "usage: %s string1 string2\n", argv[0]);
		exit(1);
	}

	cmp = cmpstr(argv[1], argv[2]);
	switch(cmp) {
	case 0:
		rel = "==";
		break;
	case 1:
		rel = ">";
		break;
	case 2:
		rel = "<";
		break;
	default:
		printf("cmp ans = %i", cmp);
		assert(0);
	}

	printf("\"%s\" %s \"%s\"\n", argv[1], rel, argv[2]);

	return cmp;
}
