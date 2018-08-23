package gameFeatures;

import tokenizer.StringMessage;

public abstract class Game<T> {

	protected String name;
	protected Room<T> room;
	protected GameLogic<T> logic = GameLogic.getInstance();
	
	public Game(String name, Room<T> room){
		this.name = name;
		this.room = room;
	}
	
	public Room<T> getRoom(){
		return room;
	}
	
	public String getName(){
		return name;
	}
		
	public void askTxt (Player<T> player, String msg){
		player.sendUserMsg(new StringMessage("ASKTXT: "+msg+"\n"));
	}
	
	public void askChoises (Player<T> player, String msg){
		player.sendUserMsg(new StringMessage("ASKCHOISES: "+msg+"\n"));
	}

	
	public abstract void getTxt(Player<StringMessage> currentPlayer, String param);

	public abstract void getChoises(Player<StringMessage> currentPlayer, String param);
	
	public abstract void startPlay();


}

