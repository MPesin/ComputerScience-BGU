all: ass0

ass0: main_ass0[2].o myasm.o
	gcc -m32 -g -Wall -ansi -o ass0 main_ass0[2].o myasm.o
	
main_ass0[2].o: main_ass0[2].c 
	gcc -m32 -g -Wall -ansi -c -o main_ass0[2].o main_ass0[2].c
	
myasm.o: myasm.s
	nasm -g -f elf -w+all -o myasm.o myasm.s


.PHONY : clean
clean :
	rm -f *.o ass0
