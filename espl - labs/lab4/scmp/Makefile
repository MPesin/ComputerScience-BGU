all: scmp

scmp: scmp.o 
	gcc -g -m64 -Wall -o scmp scmp.o

scmp.o: scmp.c
	gcc -g -m64 -Wall -o scmp.o -c scmp.c

.PHONY: clean
	

.PHONY: clean
clean:
	rm -rf *.o scmp
