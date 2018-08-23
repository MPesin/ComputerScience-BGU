all: char2ascii

char2ascii: task1a.o task1b.o task1c.o task2.o main.o 
	gcc -g -Wall -o char2ascii task1a.o task1b.o task1c.o task2.o main.o 
	
task1a.o: task1a.c
	gcc -g -Wall -ansi -c -o task1a.o  task1a.c
	
task1b.o: task1b.c
	gcc -g -Wall -ansi -c -o task1b.o  task1b.c
	
task1c.o: task1c.c
	gcc -g -Wall -ansi -c -o task1c.o  task1c.c
	
task2.o: task2.c
	gcc -g -Wall -ansi -c -o task2.o  task2.c
	
main.o: main.c
	gcc -g -Wall -ansi -c -o main.o  main.c


.PHONY: clean

clean: 
	rm -f *.o char2ascii