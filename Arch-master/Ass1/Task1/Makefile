all: ass1

ass1: main2.o task2.o
	gcc -g -m32 -Wall -o funcA cfuncA.o funcA.o 

task2.o: task2.s
	nasm -g -f elf -w+all -o task2.o task2.s
	
main2.o:
	gcc -g -Wall -m32 -ansi -c main2.c -o main2.o 


.PHONY : clean
clean :
	rm -f *.o ass1