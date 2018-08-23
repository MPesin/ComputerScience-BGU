package gameFeatures;

import java.io.IOException;

import protocol.ProtocolCallback;
import tokenizer.StringMessage;

public class Player<T> {
	private final String name;
	private int score;
	private Room<T> room;
	private ProtocolCallback call;

	public Player(String name, ProtocolCallback call){
		this.name = name;
		score = 0;
		room = null;
		this.call = call;

	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	
	public void sendUserMsg(StringMessage msg){
		try {
			call.sendMessage(msg);
		} catch (IOException e) {
			System.out.println("Error sending: "+msg.getMessage()+"\n");
			e.printStackTrace();
		}
	}
	
	/**
	 * @return the score
	 */
	public int getScore() {
		return score;
	}

	/**
	 * @param score the score to set
	 */
	public void addPoints(int score) {
		this.score += score;
	}

	/**
	 * @return the room
	 */
	public Room<T> getRoom() {
		return room;
	}

	/**
	 * @param room the room to set
	 */
	public void enterRoom(Room<T> room) {
			this.room = room;
			this.score = 0;
	}
	
	public String print(){
		return "<"+name+"> : "+score+"\n";
	}

	public void sendUserMsgGame(StringMessage stringMessage) {
		String ans= "GAMEMSG: "+stringMessage.getMessage();
		sendUserMsg(new StringMessage(ans));
	}
}

