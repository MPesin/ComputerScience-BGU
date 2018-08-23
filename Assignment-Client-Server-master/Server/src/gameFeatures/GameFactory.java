package gameFeatures;

public interface GameFactory<T> {
	public Game<T> create(Room<T> room);
}
