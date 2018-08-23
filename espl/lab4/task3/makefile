all: task3

task3: task3.o funcA.o
	ld -melf_i386 -o task3 task3.o funcA.o -lc -I/lib/ld-linux.so.2 -lc

task3.o: task3.asm
	nasm -g -f elf -w+all -o task3.o task3.asm
	
funcA.o: funcA.asm
	nasm -g -f elf -w+all -o funcA.o funcA.asm


.PHONY : clean
clean :
	rm -f *.o funcA
