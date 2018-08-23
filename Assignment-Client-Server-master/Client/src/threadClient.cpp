#include <stdlib.h>
#include <boost/locale.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include "../include/connectionHandler.h"
#include "../include/utf8.h"
#include "../include/encoder.h"


void stdinThread(ConnectionHandler * connectionHandler){

	const short bufsize = 1024;
	char buf[bufsize];
	std::cin.getline(buf, bufsize);
	std::string line(buf);
	bool status = connectionHandler->sendLine(line);
	while(status) {
		std::cin.getline(buf, bufsize);
		std::string line(buf);
		status = connectionHandler->sendLine(line);
		if (line == "QUIT") {
			std::cout << "Exiting...\n" << std::endl;
			//std::terminate();
			status = false;
		}
	}
	connectionHandler->close();
	std::terminate();
}

void listenThread(ConnectionHandler * connectionHandler){
	std::string answer;
	while(connectionHandler->getLine(answer)) {
		if (answer != "") std::cout << answer;
		if (answer == "QUIT") {
			std::cout << "Exiting...\n" << std::endl;
			std::terminate();
		}
		answer = "";
	}
	connectionHandler->close();
	std::terminate();
}

/**
 * This code assumes that the server replies the exact text the client sent it (as opposed to the practical session example)
 */

int main (int argc, char *argv[]) {

	if (argc < 3) {
		std::cerr << "How to use: " << argv[0] << " enter_host enter_port" << std::endl << std::endl;
		return -1;
	}

	std::string host = argv[1];
	short port = atoi(argv[2]);
	ConnectionHandler connectionHandler(host, port);

	if (!connectionHandler.connect()) {
		std::cerr << "Cannot connect to " << host << ":" << port << std::endl;
		return 1;
	} else {
		std::cerr << "Connected to " << host << ":" << port << std::endl;
	}

	boost::thread t1(boost::bind(&stdinThread, &connectionHandler));
	boost::thread t2(boost::bind(&listenThread, &connectionHandler));
	t1.join();
	t2.join();

	return 0;
}
