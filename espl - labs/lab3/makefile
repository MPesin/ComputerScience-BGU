all: bcmp

bcmp: task1.o task1a.o task1b.o task1c.o
	gcc -g -Wall -o bcmp task1.o task1a.o task1b.o task1c.o
	
task1.o: task1.c
	gcc -g -Wall -ansi -c -o task1.o task1.c
	
task1a.o: task1a.c
	gcc -g -Wall -ansi -c -o task1a.o task1a.c

task1b.o: task1b.c
	gcc -g -Wall -ansi -c -o task1b.o task1b.c
	
task1c.o: task1c.c
	gcc -g -Wall -ansi -c -o task1c.o task1c.c

.PHONY: clean

clean: 
	rm -f *.o bcmp