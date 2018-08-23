package gameFeatures;

public class Room<T> {
	private final String name;
	private Game<T> game;
	private boolean inGame;
	
	
	public Room(String name){
		this.name = name;
		inGame = false;
		game = null;
	}
	
	public boolean inGame(){
		if (inGame)
			return true;
		else
			return false;
	}

	public String getName() {
		return name;
	}
	
	public Game<T> getGame() {
		return game;
	}

	public void setGame(Game<T> gameSet){
		this.game = gameSet;
	}
	
	public void changeInGameStatus(){
		inGame = !inGame;
	}
}
