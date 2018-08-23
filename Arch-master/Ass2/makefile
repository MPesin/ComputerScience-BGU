all: calc
	nasm -f elf calc.s -o calc.o
	gcc -m64 -Wall -g calc -o calc.o
	
	
.PHONY : clean
clean :
	rm -f *.o calc

	

