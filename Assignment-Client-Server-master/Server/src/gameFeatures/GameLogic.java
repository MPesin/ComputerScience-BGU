package gameFeatures;

import java.util.LinkedList;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentSkipListSet;

import blufferGame.GameBluffer;
import tokenizer.StringMessage;

public class GameLogic<T> {

	private static ConcurrentHashMap<String, GameFactory> supportedGames;
	private ConcurrentHashMap<Room<T>, LinkedList<Player<T>>> rooms;
	private ConcurrentSkipListSet<String> playersNick;

	// start of singelton
	private static class SingletonHolder {
		private static GameLogic instance = new GameLogic();
	}

	protected GameLogic(){
		rooms = new  ConcurrentHashMap<Room<T>, LinkedList<Player<T>>>();
		playersNick = new ConcurrentSkipListSet<String>();
		supportedGames = new ConcurrentHashMap<String, GameFactory>();
		supportedGames.put("BLUFFER", new GameFactory<StringMessage>() {
			public Game<StringMessage> create(Room<StringMessage> room) {
				return new GameBluffer(room);
			}
		});
	}

	public static GameLogic getInstance() {
		return SingletonHolder.instance;
	}
	// end of singelton

	public String getListOfGames(){
		String games = "Supported Games:  ";
		for(String s : supportedGames.keySet())
			games = games + s + "\t";
		return games;
	}

	public boolean isSupportedGame(String game) {
		return supportedGames.containsKey(game);
	}

	public Game<T> getSupportedGame(String game, Room<T> room) {
		return supportedGames.get(game).create(room); 
	}

	public synchronized boolean addPlayer(Player<T> player){
		if (playersNick.contains(player.getName()))
			return false;
		playersNick.add(player.getName());
		return true;
	}


	public Room<T> setRoom(String name, Player<T> player){
		if (player.getRoom()!=null)
			rooms.get(player.getRoom()).remove(player);
		Set<Room<T>> roomsNames = rooms.keySet();
		for (Room<T> r : roomsNames){
			if (r.getName().equals(name)){
				rooms.get(r).add(player);
				return r;
			}
		}	
		// room doesn't exist
		Room<T> room = new Room<T>(name);
		LinkedList<Player<T>> list = new LinkedList<Player<T>>();
		list.add(player);
		rooms.put(room, list);
		return room;
	}

	public void sendRoomMessageUser(Player<T> player, Room<T> room,String msg){
		sendRoomMessage(room,  "USRMSG: "+player.getName()+" says: ", msg);
	}

	public LinkedList<Player<T>> getRoomMembers(Room<T> room) {
		return rooms.get(room);
	}

	public void sendRoomMessage(Room<T> room, String command, String msg){
		LinkedList<Player<T>> members = rooms.get(room);
		String userMsg = command+msg+"\n";
		for (Player<T> p : members)
			p.sendUserMsg(new StringMessage(userMsg));
	}

	public synchronized void leaveServer(Player<T> player){
		if (player.getRoom() != null) rooms.get(player.getRoom()).remove(player);
		playersNick.remove(player.getName());
	}

	public void sendRoomMessageGame(Room<T> room, String printResults) {
		sendRoomMessage(room, "GAMEMSG: ", printResults);
	}

}
