all: tests

tests: tests.o
	gcc -g -Wall -o tests tests.o
        
tests.o: tests.c
	gcc -g -Wall -ansi -c -o tests.o tests.c

        
.PHONY: clean

clean: 
	rm -f *.o tests

