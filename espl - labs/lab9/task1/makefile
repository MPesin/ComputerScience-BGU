

# All Targets
all: sections 

# Tool invocations
sections: sections.o 
	gcc -g -m32 -Wall -o sections sections.o 

sections.o: sections.c elf.h
	gcc -m32 -g -Wall -ansi -c -o sections.o sections.c 

.PHONY: clean

clean: 
	rm -f *.o sections
