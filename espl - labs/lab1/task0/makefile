LIBRARY1 = -lstring -lstdlib -lstdio
LIBRARY2 = -lstdlib -lstdio

all: task0

task0: add.o main.o numbers.o
	gcc -g -Wall -o task0 add.o main.o numbers.o
        
add.o: add.s
	nasm -g -f elf64 -w+all -o add.o add.s

main.o: main.c
	gcc -g -Wall -ansi -c -o main.o $(LIBRARY1) main.c

numbers.o: numbers.c
	gcc -g -Wall -ansi -c -o numbers.o $(LIBRARY2) numbers.c
        
.PHONY: clean

clean: 
	rm -f *.o task0

