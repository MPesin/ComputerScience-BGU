
all: GameOfLife

GameOfLife: ass3.o scheduler.o coroutines.o printer.o
	gcc -m32 -g -Wall -o ass3 ass3.o scheduler.o coroutines.o printer.o
 
ass3.o: ass3.s
	nasm -g -f elf -w+all -o ass3.o ass3.s
	
scheduler.o: scheduler.s
	nasm -g -f elf -w+all -o scheduler.o scheduler.s

printer.o: printer.s
	nasm -g -f elf -w+all -o printer.o printer.s

	
coroutines.o: coroutines.s
	nasm -g -f elf -w+all -o coroutines.o coroutines.s


.PHONY: clean

clean: 
	rm -f *.o ass3 scheduler printer coroutines
