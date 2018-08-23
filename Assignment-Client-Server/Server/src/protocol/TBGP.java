package protocol;

import java.io.IOException;

import gameFeatures.*;
import reactor.ConnectionHandler;
import tokenizer.StringMessage;

public class TBGP implements AsyncServerProtocol <StringMessage> {

	private Room<StringMessage> currentRoom;
	private Player<StringMessage> currentPlayer;

	private boolean is_closing = false;

	private GameLogic<StringMessage> logic;

	public enum Command{
		NICK, JOIN, MSG, LISTGAMES, STARTGAME,
		TXTRESP, SELECTRESP, QUIT;
	}

	public TBGP(){
		currentRoom = null;
		currentPlayer = null;
		logic = GameLogic.getInstance();
	}

	private boolean commandContains(String cmd){
		for (Command i : Command.values()){
			if (i.name().equals(cmd))
				return true;
		}
		return false;
	}

	public void processMessage(StringMessage msg, ProtocolCallback callback) {
		msg.printString();
		String command = msg.getCommand();
		String param = msg.getParam();
		if (commandContains(command)){
			if (currentPlayer!=null) 
				switch(command){
				
				case "NICK":
					currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Can't change the NICK: "+currentPlayer.getName()+"\n"));
					break;

				case "JOIN":
					if (!param.equals("")){
						Room<StringMessage> toJoin = logic.setRoom(param, currentPlayer);
						if (!toJoin.inGame()){
							currentRoom = toJoin;
							currentPlayer.enterRoom(currentRoom);
							currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
						} else
							currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Can't join to "+param+". Room is running a game."+"\n"));
					} else
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Please enter room name!"+"\n"));
					break;

				case "MSG":
					if (inRoom()){
						logic.sendRoomMessageUser(currentPlayer, currentRoom, param);
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
					} else
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" You must be in a room in order to send a message"+"\n"));
					break;

				case "LISTGAMES": 
					currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+" "+logic.getListOfGames()+"\n"));
					break;

				case "STARTGAME":
					if (inRoom() && !currentRoom.inGame()){
						if (logic.isSupportedGame(param)){
							Game<StringMessage> game = logic.getSupportedGame(param, currentRoom);
							currentRoom.setGame(game);
							logic.sendRoomMessageGame(currentRoom, "Game " + param + " started");
							currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
							currentRoom.changeInGameStatus();
							currentRoom.getGame().startPlay();
						} else 
							currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Game isn't supported by this server. Use LISTGAMES command to see supported games!"+"\n"));
					}else 
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Please JOIN a room with no running game."+"\n"));
					break;

				case "TXTRESP":
					if (currentRoom.inGame()){
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
						currentRoom.getGame().getTxt(currentPlayer, param.toLowerCase());
					}
					else	
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Wait for ASKTXT."+"\n"));
					break;

				case "SELECTRESP":
					if (currentRoom.inGame()){
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
						currentRoom.getGame().getChoises(currentPlayer,param);
					}
					else
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED"+" Wait for ASKCHOISES."+"\n"));
					break;

				case "QUIT":
					if (currentPlayer != null) currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
					close(callback);
					break;

				default: currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" UNDEFINED"+"\n"));
				break;
				}
			else
				if (command.equals("NICK") && !param.equals("")){
					currentPlayer = new Player<StringMessage>(param,callback);
					if (logic.addPlayer(currentPlayer))
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" ACCEPTED"+"\n"));
					else
						currentPlayer.sendUserMsg(new StringMessage("SYSMSG "+command+" REJECTED "+"NICK already exist, please try again"+"\n"));
				} else 
					try {
						callback.sendMessage(new StringMessage("SYSMSG "+command+" REJECTED "+"Enter NICK!"+"\n"));
					} catch (IOException e) {
						e.printStackTrace();
					}
		} else {
			try {
				callback.sendMessage(new StringMessage("SYSMSG "+msg.getMessage()+" UNDEFINED"+"\n"));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	private boolean inRoom(){
		return currentRoom != null;
	}

	public boolean shouldClose() {
		return is_closing;
	}

	public void connectionTerminated() {
		if (currentPlayer != null) logic.leaveServer(currentPlayer);
		is_closing = true;
	}

	public void close(ProtocolCallback callback){
		if (currentPlayer != null) logic.leaveServer(currentPlayer);
		is_closing = true;
		try {
			callback.sendMessage(new StringMessage("QUIT"));
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	public boolean isEnd(StringMessage msg) {
		return msg.getMessage().equals("QUIT");
	}
}