
# All Targets
all: mypipe 

mypipe: mypipeline.o LineParser.o
	gcc -g -m32 -Wall -o mypipe mypipeline.o LineParser.o

mypipeline.o: mypipeline.c 
	gcc -m32 -g -Wall -ansi -c -o mypipeline.o mypipeline.c 
	
LineParser.o: LineParser.c LineParser.h
	gcc -m32 -g -Wall -ansi -c -o  LineParser.o LineParser.c 

.PHONY: clean

clean: 
	rm -f *.o mypipe
