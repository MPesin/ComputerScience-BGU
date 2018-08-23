

# All Targets
all: examine 

# Tool invocations
examine: examine.o 
	gcc -g -m32 -Wall -o examine examine.o 

examine.o: examine.c elf.h
	gcc -m32 -g -Wall -ansi -c -o examine.o examine.c 

.PHONY: clean

clean: 
	rm -f *.o examine
