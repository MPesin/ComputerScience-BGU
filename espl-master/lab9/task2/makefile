

# All Targets
all: symbols 

# Tool invocations
symbols: symbols.o 
	gcc -g -m32 -Wall -o symbols symbols.o 

symbols.o: symbols.c elf.h
	gcc -m32 -g -Wall -ansi -c -o symbols.o symbols.c 

.PHONY: clean

clean: 
	rm -f *.o symbols
