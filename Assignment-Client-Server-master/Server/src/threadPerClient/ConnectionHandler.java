package threadPerClient;

import java.io.*;
import java.net.*;

import protocol.ServerProtocol;
import tokenizer.StringMessage;

class ConnectionHandler<T> implements Runnable {
	
	private BufferedReader in;
	private PrintWriter out;
	Socket clientSocket;
	ServerProtocol<T> protocol;
	
	public ConnectionHandler(Socket acceptedSocket, ServerProtocol<T> p)
	{
		in = null;
		out = null;
		clientSocket = acceptedSocket;
		protocol = p;
		System.out.println("Accepted connection from client!");
		System.out.println("The client is from: " + acceptedSocket.getInetAddress() + ":" + acceptedSocket.getPort());
	}
	
	public void run()
	{

		try {
			initialize();
		}
		catch (IOException e) {
			System.out.println("Error in initializing I/O");
		}

		try {
			process();
		} 
		catch (IOException e) {
			System.out.println("Error in I/O");
		} 
		
		System.out.println("Client has left the game. Bye Bye... :)");
		close();

	}
	
	public void process() throws IOException
	{
		StringMessage msg;
		
		while ((msg = new StringMessage(in.readLine())).getMessage() != "")
		{
			System.out.println("Received \"" + msg + "\" from client");
			
			protocol.processMessage((T)msg, response->{
				if (response != null){
					out.println(response.getMessage());
				}
				
				if (protocol.isEnd((T)response)){
					close();
				}
			});	
			
			if (protocol.isEnd((T)msg))
			{
				break;
			}
			
		}
	}
	
	// Starts listening
	public void initialize() throws IOException
	{
		// Initialize I/O
		in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream(),"UTF-8"));
		out = new PrintWriter(new OutputStreamWriter(clientSocket.getOutputStream(),"UTF-8"), true);
		System.out.println("I/O initialized");
	}
	
	// Closes the connection
	public void close()
	{
		try {
			if (in != null)
			{
				in.close();
			}
			if (out != null)
			{
				out.close();
			}
			
			clientSocket.close();
		}
		catch (IOException e)
		{
			System.out.println("Exception in closing I/O");
		}
	}
	
}