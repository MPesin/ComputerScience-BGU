all: addresses

addresses: addresses.o
	gcc -g -Wall -o addresses addresses.o

addresses.o: addresses.c
	gcc -g -Wall -ansi -c -o addresses.o addresses.c
