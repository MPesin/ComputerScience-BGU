# define some Makefile variables for the compiler and compiler flags
# to use Makefile variables later in the Makefile: $()
CC = g++
CFLAGS  = -g -Wall -Weffc++
LFLAGS  = -L/usr/lib -lboost_system -lboost_thread -lboost_locale


# All Targets
all: Client

# Tool invocations
Client: bin/threadClient.o bin/connectionHandler.o bin/encoder.o 
	$(CC) -o bin/Client bin/threadClient.o bin/connectionHandler.o bin/encoder.o $(LFLAGS)


# Depends on the source and header files
bin/threadClient.o: src/threadClient.cpp
	$(CC) $(CFLAGS) -c -Linclude -o bin/threadClient.o src/threadClient.cpp

	
# Depends on the source and header files 
bin/connectionHandler.o: src/connectionHandler.cpp
	$(CC) $(CFLAGS) -c -Linclude -o bin/connectionHandler.o src/connectionHandler.cpp


# Depends on the source and header files 
bin/encoder.o: src/encoder.cpp
	$(CC) $(CFLAGS) -c -Linclude -o bin/encoder.o src/encoder.cpp


#Clean the build directory
clean: 
	rm -f bin/*
