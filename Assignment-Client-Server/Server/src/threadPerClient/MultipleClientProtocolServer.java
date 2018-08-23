package threadPerClient;

import java.io.*;
import java.net.*;

import protocol.*;
import tokenizer.StringMessage;

public class MultipleClientProtocolServer<T> implements Runnable {
	private ServerSocket serverSocket;
	private int listenPort;
	private ServerProtocolFactory<T> factory;

	public MultipleClientProtocolServer(int port, ServerProtocolFactory<T> p)
	{
		serverSocket = null;
		listenPort = port;
		factory = p;
	}

	public void run()
	{
		try {
			serverSocket = new ServerSocket(listenPort);
			System.out.println("Listening...");
		}
		catch (IOException e) {
			System.out.println("Cannot listen on port " + listenPort);
		}

		while (true)
		{
			try {
				ConnectionHandler<T> newConnection = new ConnectionHandler(serverSocket.accept(), factory.create());
				new Thread(newConnection).start();
			}
			catch (IOException e)
			{
				System.out.println("Failed to accept on port " + listenPort);
			}
		}
	}

	// Closes the connection
	public void close() throws IOException{
		serverSocket.close();
	}

	public static void main(String[] args) throws IOException{
		// Get port
		int port = Integer.decode(args[0]).intValue();

		MultipleClientProtocolServer<StringMessage> server = new MultipleClientProtocolServer<StringMessage>(port, new ServerProtocolFactory<StringMessage>(){
			public AsyncServerProtocol<StringMessage> create(){
				return new TBGP();
			}
		});

		Thread serverThread = new Thread(server);
		serverThread.start();
		try {
			serverThread.join();
		} catch (InterruptedException e){
			System.out.println("Server stopped");
		}		
	}	

}
