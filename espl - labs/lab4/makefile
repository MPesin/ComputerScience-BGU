all: funcA

funcA: cfuncA.o funcA.o
	gcc -g -m32 -Wall -o funcA cfuncA.o funcA.o 

funcA.o: funcA.asm
	nasm -g -f elf -w+all -o funcA.o funcA.asm
	
cfuncA.o:
	gcc -g -Wall -m32 -ansi -c cfuncA.c -o cfuncA.o 


.PHONY : clean
clean :
	rm -f *.o funcA